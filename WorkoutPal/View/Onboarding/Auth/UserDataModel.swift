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
import FirebaseFirestoreSwift

enum UserGenderID: String, CaseIterable {
    case none = "None"
    case male = "Male"
    case female = "Female"
}

enum AppStates {
    case signedIn, signedOut
}

class UserDataModel: ObservableObject {
    @Published var userInfo = UserModel(user_name: "", user_email: "", user_handle: "", user_gender: "",user_bio: "", user_id: "", user_profileURL: "", liked_post: [], followed: [], following: [])
    @Published var appState: AppStates = .signedOut
    @Published var userProfilePhoto: UIImage?
    @Published var userPickerImage: PhotosPickerItem?
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
    
    func checkLogin(){
        let currentUser = Auth.auth().currentUser
        if currentUser != nil {
            if let id = currentUser?.uid{
                self.userInfo.user_id = id
                let userRef = Firestore.firestore().collection("users").document(id).addSnapshotListener { DocumentSnapshot, Error in
                    guard let doc = try? DocumentSnapshot?.data(as: UserModel.self) else {return }
                    self.userInfo = doc
                    self.isLoading = false
                    self.appState = .signedIn
                }
            }
        }
    }
    
    func updateBio(newBio: String) {
        Firestore.firestore().collection("users").document(self.userInfo.id!).setData(["user_bio": newBio], merge: true)
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
    
    @MainActor
    func emailLogin(email: String, password: String) async {
        self.isLoading = true
        do{
            let userSignInfo = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userInfo.user_id = userSignInfo.user.uid
            
            let userRef = Firestore.firestore().collection("users").document(self.userInfo.user_id).addSnapshotListener { DocumentSnapshot, Error in
                
                guard let doc = try? DocumentSnapshot?.data(as: UserModel.self) else {return }
                self.userInfo = doc
                self.isLoading = false
                self.appState = .signedIn
            }
        } catch{
            self.errorMessage = self.setErrorMessage(errorCode: AuthErrors.failedSignIn)
            try! Auth.auth().signOut()
            self.appState = .signedOut
        }
    }
    
    // Email Signup Function
    @MainActor
    func emailSignUp(user: UserModel, password: String) async {
        self.isLoading = true
        var newUserInfo = user
        do {
            if userPickerImage == nil {
                throw AuthErrors.noProfilePic
            }
            let newUser = try await Auth.auth().createUser(withEmail: newUserInfo.user_email, password: password)
            let id = newUser.user.uid
            guard let imageData = try await userPickerImage?.loadTransferable(type: Data.self) else { return }
            let storageRef = Storage.storage().reference().child("profile_images").child(id)
            _ = try await storageRef.putDataAsync(imageData)
            let downloadURL = try await storageRef.downloadURL()
            newUserInfo.user_profileURL = downloadURL.absoluteString
            newUserInfo.user_id = id
            try Firestore.firestore().collection("users").document(id).setData(from: newUserInfo)
            checkLogin()
            self.isLoading = false
        } catch {
            self.errorMessage = setErrorMessage(errorCode: error)
        }
    }
    
    func removeLike(post: MessageFeed) async {
        do{
            try await Firestore.firestore().collection("users").document(self.userInfo.id!).updateData(["liked_post":FieldValue.arrayRemove([post.id])])
            
            var likedMessage = try await Firestore.firestore().collection("feed").document(post.id!).getDocument(as: MessageFeed.self)
            
            var editLike = likedMessage
            
            editLike.feed_like_count -= 1
            if editLike.feed_like_count < 0{
                editLike.feed_like_count = 0
            }
            try Firestore.firestore().collection("feed").document(post.id!).setData(from: editLike)
        } catch{
            print("Error Removing Like")
        }
    }
    
    func follow(_ otherUser: UserModel){
        Firestore.firestore().collection("users").document(self.userInfo.id!).updateData(["followed":FieldValue.arrayUnion([otherUser.id!])])
        Firestore.firestore().collection("users").document(otherUser.id!).updateData(["following":FieldValue.arrayUnion([self.userInfo.id!])])
    }
    
    func unFollow(_ otherUser: UserModel){
        Firestore.firestore().collection("users").document(self.userInfo.id!).updateData(["followed":FieldValue.arrayRemove([otherUser.id!])])
        Firestore.firestore().collection("users").document(otherUser.id!).updateData(["following":FieldValue.arrayRemove([self.userInfo.id!])])
    }
    
    func likePost(post: MessageFeed) async {
        do{
            try await Firestore.firestore().collection("users").document(self.userInfo.user_id).updateData(["liked_post": FieldValue.arrayUnion([post.id])])
            
            var likedPost = try await Firestore.firestore().collection("feed").document(post.id!).getDocument(as: MessageFeed.self)
            
            var editPost = likedPost
            
            editPost.feed_like_count += 1
            
            try Firestore.firestore().collection("feed").document(post.id!).setData(from: editPost)
        } catch{
            print("Erorr")
        }
            
        
        
    }
    // Signout Current User
    func signOutUser() {
        do {
            self.isLoading = true
            try Auth.auth().signOut()
            self.userInfo = UserModel(user_name: "", user_email: "", user_handle: "", user_gender: "",user_bio: "", user_id: "", user_profileURL: "", liked_post: [], followed: [], following: [])
            userProfilePhoto = nil
            userPickerImage = nil
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
