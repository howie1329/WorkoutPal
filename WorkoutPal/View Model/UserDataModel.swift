//
//  UserDataModel.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 5/21/23.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseAuth
import _PhotosUI_SwiftUI

enum UserGenderID: String, CaseIterable {
    case none = "None"
    case male = "Male"
    case female = "Female"
}

enum AppStates {
    case signedIn, signedOut
}

class UserDataModel: ObservableObject {
    @Published var userID = ""
    @Published var userName = ""
    @Published var userEmail = ""
    @Published var userGender: String = "none"
    @Published var userHandle = ""
    @Published var appState: AppStates = .signedOut
    @Published var userProfilePhoto: UIImage?
    @Published var userPickerImage: PhotosPickerItem?
    @Published var userUrl: String = ""
    @Published var userLikedPost: [String] = []
    @Published var userBio: String = ""
    @Published var userDocID: String = ""
    @Published var isLoading: Bool = false
    @Published var isError: Bool = false
    @Published var errorMessage: String = ""
    init() {
    }
    // Move to Service File
    func setErrorMessage(errorCode: Error) -> String {
        self.isLoading = false
        self.isError = true
        return errorCode.localizedDescription
    }
    // Get users profile picture
    @MainActor
    func getProfilePhoto()async {
        do {
            guard let imageData = try await userPickerImage?.loadTransferable(type: Data.self) else { return }
            self.userProfilePhoto = UIImage(data: imageData)
        } catch {
            self.errorMessage = setErrorMessage(errorCode: error)
        }
    }
    // Check if a user is already logged in
    @MainActor
    func checkLogin() async {
        let currentUser = Auth.auth().currentUser
        if currentUser != nil {
            if let userInfo = currentUser {
                self.userID = userInfo.uid
                let userRef = Firestore.firestore().collection("users").whereField("user_id", isEqualTo: userInfo.uid).addSnapshotListener { QuerySnapshot, Error in
                    if Error == nil {
                        if let snapShot = QuerySnapshot {
                            for doc in snapShot.documents {
                                let data = doc.data()
                                self.userDocID = doc.documentID
                                self.userName = data["user_name"] as! String
                                self.userID = data["user_id"] as! String
                                self.userEmail = data["user_email"] as! String
                                self.userGender = data["user_gender"] as! String
                                self.userHandle = data["user_handle"] as! String
                                self.userUrl = data["user_profileURL"] as! String
                                self.userLikedPost = data["liked_post"] as! [String]
                                self.userBio = data["user_bio"] as? String ?? "No Bio Please Update"
                                self.appState = .signedIn
                            }
                        }
                    } else {
                        self.errorMessage = self.setErrorMessage(errorCode: AuthErrors.failedSignIn)
                        try! Auth.auth().signOut()
                        self.appState = .signedOut
                    }
                }
                if Auth.auth().currentUser == nil {
                    userRef.remove()
                }
            }
        }
    }
    @MainActor
    func updateBio(newBio: String) async {
        do {
            _ = try await Firestore.firestore().collection("users").document(self.userDocID).setData(["user_bio": newBio], merge: true)
        } catch {
            self.errorMessage = setErrorMessage(errorCode: AuthErrors.failedUpdate)
        }
    }
    // Reset Password Function
    @MainActor
    func resetPassword(email: String) async {
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
        } catch {
            self.errorMessage = setErrorMessage(errorCode: AuthErrors.failedReset)
        }
    }
    // Email Login Function
    @MainActor
    func emailLogin(email: String, password: String) async {
        self.isLoading = true
        do {
            let userSignInfo = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userID = userSignInfo.user.uid
            let userRef = Firestore.firestore().collection("users").whereField("user_id", isEqualTo: userSignInfo.user.uid).addSnapshotListener { QuerySnapshot, Error in
                if Error == nil {
                    if let snapShot = QuerySnapshot {
                        for doc in snapShot.documents {
                            let data = doc.data()
                            self.userDocID = doc.documentID
                            self.userName = data["user_name"] as! String
                            self.userID = data["user_id"] as! String
                            self.userEmail = data["user_email"] as! String
                            self.userGender = data["user_gender"] as! String
                            self.userHandle = data["user_handle"] as! String
                            self.userUrl = data["user_profileURL"] as! String
                            self.userLikedPost = data["liked_post"] as! [String]
                            self.userBio = data["user_bio"] as? String ?? "No Bio Please Update"
                            self.isLoading = false
                            self.appState = .signedIn
                        }
                    }
                } else {
                    self.errorMessage = self.setErrorMessage(errorCode: Error!)
                    try! Auth.auth().signOut()
                    self.appState = .signedOut
                }
            }
            if Auth.auth().currentUser == nil {
                userRef.remove()
            }
        } catch {
            self.errorMessage = setErrorMessage(errorCode: error)
        }
    }
    // Email Signup Function
    @MainActor
    func emailSignUp(name: String, email: String, password: String, gender: UserGenderID, handle: String, bio: String) async {
        self.isLoading = true
        do {
            if userPickerImage == nil {
                throw AuthErrors.noProfilePic
            }
            let newUser = try await Auth.auth().createUser(withEmail: email, password: password)
            let id = newUser.user.uid
            guard let imageData = try await userPickerImage?.loadTransferable(type: Data.self) else { return }
            let storageRef = Storage.storage().reference().child("profile_images").child(id)
            _ = try await storageRef.putDataAsync(imageData)
            let downloadURL = try await storageRef.downloadURL()
            _ = Firestore.firestore().collection("users").addDocument(data: ["user_name": name, "user_email": email, "user_id": id, "user_gender": gender.rawValue, "user_handle": handle, "user_profileURL": downloadURL.absoluteString, "liked_post": ["none"], "user_bio": bio])
            await checkLogin()
            self.isLoading = false
        } catch {
            self.errorMessage = setErrorMessage(errorCode: error)
        }
    }
    func removeLike(post: MessageFeed) {
        Firestore.firestore().collection("users").whereField("user_id", isEqualTo: self.userID).getDocuments { QuerySnapshot, Error in
            if Error == nil {
                if let snapShot = QuerySnapshot {
                    for doc in snapShot.documents {
                        let documentID = doc.documentID
                        _ = Firestore.firestore().collection("users").document(documentID)
                        Firestore.firestore().collection("feed").document(post.id).getDocument { DocumentSnapshot, Error in
                            if Error == nil {
                                if let doc = DocumentSnapshot {
                                    if let data = doc.data() {
                                        var oldLikeCount = data["feed_like_count"] as! Int
                                        oldLikeCount -= 1
                                        if oldLikeCount <= 0 {
                                            oldLikeCount = 0
                                        }
                                        Firestore.firestore().collection("feed").document(post.id).updateData(["feed_like_count": oldLikeCount])
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    func likePost(post: MessageFeed) {
        Firestore.firestore().collection("users").whereField("user_id", isEqualTo: self.userID).getDocuments(completion: { QuerySnapshot, Error in
            if Error == nil {
                if let snapShot = QuerySnapshot {
                    for doc in snapShot.documents {
                        let documentID = doc.documentID
                        Firestore.firestore().collection("users").document(documentID).updateData(["liked_post": FieldValue.arrayUnion([post.id])])
                        Firestore.firestore().collection("feed").document(post.id).getDocument { DocumentSnapshot, Error in
                            if Error == nil {
                                if let doc = DocumentSnapshot {
                                    if let data = doc.data() {
                                        var oldLikeCount = data["feed_like_count"] as! Int
                                        oldLikeCount += 1
                                        if oldLikeCount <= 0 {
                                            oldLikeCount = 0
                                        }
                                        Firestore.firestore().collection("feed").document(post.id).updateData(["feed_like_count": oldLikeCount])
                                    }
                                }
                            }
                        }
                    }
                }
            }
        })
    }
    // Signout Current User
    func signOutUser() {
        do {
            self.isLoading = true
            try Auth.auth().signOut()
            userID = ""
            userName = ""
            userEmail = ""
            userHandle = ""
            userGender = "none"
            userUrl = ""
            userProfilePhoto = nil
            userPickerImage = nil
            userLikedPost = []
            self.isLoading = false
            appState = .signedOut
        } catch let error {
            self.errorMessage = setErrorMessage(errorCode: error)
        }
    }
    func checkingSignupValidation(email: String, password: String, confirm: String, handle: String, name: String) throws -> Bool {
        if email != "", password != "", handle != "", name != "" && password == confirm {
            return true
        } else {
            return false
        }
    }
}
