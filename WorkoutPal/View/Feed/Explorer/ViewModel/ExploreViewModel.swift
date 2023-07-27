//
//  ExploreViewModel.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 7/11/23.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class ExploreViewModel: ObservableObject {
    
    @Published var allUsers: [UserModel] = []
    @Published var searchBar:String = ""
    
    var searchableUsers: [UserModel] {
        if searchBar.isEmpty {
            return allUsers
        } else {
            let lowercaseSearch = searchBar.lowercased()
            return allUsers.filter { userItem in
                userItem.user_handle.lowercased().contains(lowercaseSearch) ||
                userItem.user_name.lowercased().contains(lowercaseSearch)
            }
        }
    }
    
    init(){
        getAllUsers()
    }
    
    func getAllUsers(){
        Firestore.firestore().collection("users").getDocuments { QuerySnapshot, Error in
            
            guard let userDocs = QuerySnapshot?.documents else {return }
            
            self.allUsers = userDocs.compactMap({try? $0.data(as: UserModel.self)})
        }
    }
}
