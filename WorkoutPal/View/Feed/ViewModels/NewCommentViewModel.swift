//
//  NewCommentViewModel.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 7/10/23.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class NewCommentViewModel {
    
    func createComment(newComment: Comment, oringalMessage: MessageFeed){
        guard let feedID = oringalMessage.id else {return}
        let dbRef = Firestore.firestore().collection("feed").document(feedID).collection("comments").document()
        do{
            _ = try dbRef.setData(from: newComment)
        } catch{
           print("ERROR")
        }
    }
}
