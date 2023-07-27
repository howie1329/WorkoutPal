//
//  ExploreProfileViewModel.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 7/11/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class ExploreProfileViewModel: ObservableObject {
    
    @Published var feed: [MessageFeed] = []
    
    func fetchProfilePost(user: UserModel){
        Firestore.firestore().collection("feed").whereField("feed_author_id", isEqualTo: user.user_id).getDocuments { QuerySnapshot, Error in
            
            guard let documents = QuerySnapshot?.documents else {return }
            
            self.feed = documents.compactMap({try? $0.data(as: MessageFeed.self)})
        }
    }
}
