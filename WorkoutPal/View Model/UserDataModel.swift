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

enum userGenderID: String, CaseIterable{
    case male = "Male"
    case female = "Female"
    case none = "None"
}

enum appStates{
    case signedIn,signedOut
}

class UserDataModel: ObservableObject {
    
    @Published var userID = ""
    @Published var userName = ""
    @Published var userEmail = ""
    @Published var userGender:String = "none"
    @Published var userHandle = ""
    @Published var appState:appStates = .signedOut
    @Published var userProfilePhoto: UIImage? = nil
    @Published var userPickerImage: PhotosPickerItem? = nil
    @Published var userUrl:String = ""
    
    @Published var isLoading: Bool = false
    
    @Published var isError: Bool = false
    @Published var errorMessage: String = ""
    
    init(){
    }
    
    // Move to Service File
    func setErrorMessage(errorCode: Error) -> String{
        self.isLoading = false
        self.isError = true
        return errorCode.localizedDescription
    }
    
    // Get users profile picture
    @MainActor
    func getProfilePhoto()async {
        do{
            guard let imageData = try await userPickerImage?.loadTransferable(type: Data.self)else{return}
            
            self.userProfilePhoto = UIImage(data: imageData)
        } catch{
            self.errorMessage = setErrorMessage(errorCode: error)
        }
    }
    
    // Check if a used is cached
    @MainActor
    func checkLogin() async {
        let currentUser = Auth.auth().currentUser
        if currentUser != nil {
            if let userInfo = currentUser{
                self.userID = userInfo.uid
                
                do{
                    let dbResults = try await Firestore.firestore().collection("users").whereField("user_id", isEqualTo: userInfo.uid).getDocuments()
                    
                    for doc in dbResults.documents {
                        let data = doc.data()
                        
                        self.userName = data["user_name"] as! String
                        self.userID = data["user_id"] as! String
                        self.userEmail = data["user_email"] as! String
                        self.userGender = data["user_gender"] as! String
                        self.userHandle = data["user_handle"] as! String
                        self.userUrl = data["user_profileURL"] as! String
                        
                        self.appState = .signedIn
                    }
                } catch{
                    self.errorMessage = setErrorMessage(errorCode: error)
                    try! Auth.auth().signOut()
                    self.appState = .signedOut
                }
            }
        }
    }
    
    // Email Login Function
    @MainActor
    func emailLogin(email: String, password: String) async {
        self.isLoading = true
        do{
            let userSignInfo = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userID = userSignInfo.user.uid
            
            let databaseResults = try await Firestore.firestore().collection("users").whereField("user_id", isEqualTo: userSignInfo.user.uid).getDocuments()
            
            for doc in databaseResults.documents{
                let data = doc.data()
                
                self.userName = data["user_name"] as! String
                self.userID = data["user_id"] as! String
                self.userEmail = data["user_email"] as! String
                self.userGender = data["user_gender"] as! String
                self.userHandle = data["user_handle"] as! String
                self.userUrl = data["user_profileURL"] as! String
                
                self.isLoading = false
                self.appState = .signedIn
            }
        } catch{
            self.errorMessage = setErrorMessage(errorCode: error)
        }
    }
    
    
    
    // Email Signup Function
    @MainActor
    func emailSignUp(name:String, email:String, password:String, gender:userGenderID, handle:String) async {
        self.isLoading = true
        do{
            if userPickerImage == nil {
                throw AuthErrors.noProfilePic
            }
            let newUser = try await Auth.auth().createUser(withEmail: email, password: password)
            let id = newUser.user.uid
            
            guard let imageData = try await userPickerImage?.loadTransferable(type: Data.self) else{return}
            
            let storageRef = Storage.storage().reference().child("profile_images").child(id)
            let _ = try await storageRef.putDataAsync(imageData)
            let downloadURL = try await storageRef.downloadURL()
            
            
            let _ = Firestore.firestore().collection("users").addDocument(data: ["user_name" : name, "user_email": email, "user_id": id, "user_gender": gender.rawValue, "user_handle": handle, "user_profileURL": downloadURL.absoluteString])
            
            await checkLogin()
            self.isLoading = false
        } catch{
            self.errorMessage = setErrorMessage(errorCode: error)
        }
        
    }
    
    // Signout Current User
    func signOutUser(){
        do{
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
            self.isLoading = false
            appState = .signedOut
        } catch let error {
            self.errorMessage = setErrorMessage(errorCode: error)
        }
    }
}
