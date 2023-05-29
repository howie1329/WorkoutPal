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
    
    init(){
        //emailSignUp(name: "howarddasd", email: "howardasd@test.com", password: "teadsst12345", gender: .male)
        //emailLogin(email: "howard@test.com", password: "test12345")
    }
    
    @MainActor
    func getProfilePhoto()async {
        do{
            guard let imageData = try await userPickerImage?.loadTransferable(type: Data.self)else{return}
            
            self.userProfilePhoto = UIImage(data: imageData)
        } catch{
            print("Error On Photo")
        }
    }
    
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
                        let storageRef = Storage.storage().reference(forURL: self.userUrl)
                        storageRef.getData(maxSize: 3 * 1024 * 1024) { data, error in
                            if error == nil {
                                if let data = data{
                                    self.userProfilePhoto = UIImage(data: data)
                                    print("Image test")
                                }
                            }
                        }
                        self.appState = .signedIn
                    }
                } catch{
                    print("Error Getting Info \(error.localizedDescription)")
                    try! Auth.auth().signOut()
                    self.appState = .signedOut
                }
            }
        }
    }
    
    @MainActor
    func emailLogin(email: String, password: String) async {
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
                let storageRef = Storage.storage().reference(forURL: self.userUrl)
                storageRef.getData(maxSize: 3 * 1024 * 1024) { data, error in
                    if error == nil {
                        if let data = data{
                            self.userProfilePhoto = UIImage(data: data)
                            print("Image test")
                        }
                    }
                }
                
                self.appState = .signedIn
            }
        } catch{
            print("Error Signing In \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func emailSignUp(name:String, email:String, password:String, gender:userGenderID, handle:String) async {
        do{
            let newUser = try await Auth.auth().createUser(withEmail: email, password: password)
            let id = newUser.user.uid
            
            guard let imageData = try await userPickerImage?.loadTransferable(type: Data.self) else{return}
            
            let storageRef = Storage.storage().reference().child("profile_images").child(id)
            try await storageRef.putDataAsync(imageData)
            let downloadURL = try await storageRef.downloadURL()
            
            let dbResults = Firestore.firestore().collection("users").addDocument(data: ["user_name" : name, "user_email": email, "user_id": id, "user_gender": gender.rawValue, "user_handle": handle, "user_profileURL": downloadURL.absoluteString])
            await checkLogin()
        } catch{
            print("Error on Signin \(error.localizedDescription)")
        }
        
    }
    
    func signOutUser(){
        do{
            try Auth.auth().signOut()
            userID = ""
            userName = ""
            userEmail = ""
            userHandle = ""
            userGender = "none"
            userUrl = ""
            userProfilePhoto = nil
            userPickerImage = nil
            appState = .signedOut
        } catch let error {
            print("Error During Signout \(error)")
        }
    }
}
