//
//  UserDataModel.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 5/21/23.
//

import Foundation
import Firebase
import FirebaseAuth

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
    
    init(){
        //emailSignUp(name: "howarddasd", email: "howardasd@test.com", password: "teadsst12345", gender: .male)
        //emailLogin(email: "howard@test.com", password: "test12345")
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
            let dbResults = Firestore.firestore().collection("users").addDocument(data: ["user_name" : name, "user_email": email, "user_id": id, "user_gender": gender.rawValue, "user_handle": handle])
            await checkLogin()
        } catch{
            print("Error on Signin")
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
            appState = .signedOut
        } catch let error {
            print("Error During Signout \(error)")
        }
    }
}
