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
    @Published var userGender:userGenderID = .none
    @Published var appState:appStates = .signedOut
    
    init(){
        //emailSignUp(name: "howarddasd", email: "howardasd@test.com", password: "teadsst12345", gender: .male)
        //checkLogin()
        //emailLogin(email: "howard@test.com", password: "test12345")
    }
    
    func checkLogin(){
        let currentUser = Auth.auth().currentUser
        if currentUser != nil{
            if let user = currentUser {
                self.userID = user.uid
                let db = Firestore.firestore().collection("users")
                db.whereField("userID", isEqualTo: user.uid).getDocuments{ SnapShot, error in
                    if let snapShot = SnapShot {
                        for doc in snapShot.documents{
                            let data = doc.data()
                            
                            self.userName = data["userName"] as! String
                            self.userID = data["userId"] as! String
                            self.userEmail = data["userEmail"] as! String
                            self.userGender = data["userGender"] as! userGenderID
                            
                            self.appState = .signedIn
                            
                        }
                    }
                }
            }
        }
    }
    
    func emailLogin(email:String, password:String){
        Auth.auth().signIn(withEmail: email, password: password){ result, error in
            if error == nil {
                if let data = result{
                    self.userID = data.user.uid
                    let db = Firestore.firestore()
                    let collection = db.collection("users")
                    collection.whereField("userID", isEqualTo: data.user.uid).getDocuments { Snapshot, Error in
                        if let snapShot = Snapshot {
                            for doc in snapShot.documents{
                                let data = doc.data()
                                
                                self.userName = data["userName"] as! String
                                self.userID = data["userId"] as! String
                                self.userEmail = data["userEmail"] as! String
                                self.userGender = data["userGender"] as! userGenderID
                                
                                self.appState = .signedIn
                            }
                        }
                    }
                }
            } else if let error = error{
                print("Error During Login \(error.localizedDescription)")
            }
            
        }
    }
    
    func emailSignUp(name:String, email:String, password:String, gender:userGenderID){
        Auth.auth().createUser(withEmail: email, password: password){result ,error in
            if error == nil{
                if let data = result {
                    let id = data.user.uid
                    let db = Firestore.firestore()
                    let collection = db.collection("users")
                    collection.addDocument(data: ["userName" : name, "userEmail": email, "userId": id, "userGender": gender.rawValue])
                }
            }else if let error = error{
                print("Error on Signup \(error.localizedDescription)")
            }
        }
    }
    
    func signOutUser(){
        do{
            try Auth.auth().signOut()
            userID = ""
            userName = ""
            userEmail = ""
            userGender = .none
            appState = .signedOut
        } catch let error {
            print("Error During Signout \(error)")
        }
    }
}
