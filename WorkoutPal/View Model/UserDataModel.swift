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
        checkLogin()
        //emailLogin(email: "howard@test.com", password: "test12345")
    }
    
    func checkLogin(){
        let currentUser = Auth.auth().currentUser
        if currentUser != nil{
            if let user = currentUser {
                self.userID = user.uid
                let db = Firestore.firestore().collection("users")
                db.whereField("user_id", isEqualTo: user.uid).getDocuments{ SnapShot, error in
                    if let snapShot = SnapShot {
                        for doc in snapShot.documents{
                            print("Data Here \(doc.data()) ")
                            let data = doc.data()
                            
                            self.userName = data["user_name"] as! String
                            self.userID = data["user_id"] as! String
                            self.userEmail = data["user_email"] as! String
                            self.userGender = data["user_gender"] as! String
                            self.userHandle = data["user_handle"] as? String ?? ""
                            
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
                    collection.whereField("user_id", isEqualTo: data.user.uid).getDocuments { Snapshot, Error in
                        if let snapShot = Snapshot {
                            for doc in snapShot.documents{
                                print(doc.data())
                                let data = doc.data()
                                
                                self.userName = data["user_name"] as! String
                                self.userID = data["user_id"] as! String
                                self.userEmail = data["user_email"] as! String
                                self.userGender = data["user_gender"] as! String
                                self.userHandle = data["user_handle"] as! String
                               
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
    
    func emailSignUp(name:String, email:String, password:String, gender:userGenderID, handle:String){
        Auth.auth().createUser(withEmail: email, password: password){result ,error in
            if error == nil{
                if let data = result {
                    let id = data.user.uid
                    let db = Firestore.firestore()
                    let collection = db.collection("users")
                    collection.addDocument(data: ["user_name" : name, "user_email": email, "user_id": id, "user_gender": gender.rawValue, "user_handle": handle])
                }
            }else if let error = error{
                print("Error on Signup \(error.localizedDescription)")
            }
        }
        checkLogin()
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
