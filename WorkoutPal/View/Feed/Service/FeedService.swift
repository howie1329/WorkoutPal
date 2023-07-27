//
//  FeedService.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 7/10/23.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseStorage
import FirebaseFirestoreSwift
import _PhotosUI_SwiftUI

struct FeedService{
    
    func fetchFeed(completion: @escaping([MessageFeed]) -> ()){
        var feed: [MessageFeed] = []
        _ = Firestore.firestore().collection("feed").order(by: "feed_timestamp",descending: true).addSnapshotListener { QuerySnapshot, Error in
            
            
            guard let documents = QuerySnapshot?.documents else {return}
            
            let finalFeedMessages = documents.compactMap({try? $0.data(as: MessageFeed.self)})
            
            feed = finalFeedMessages
            
            for messageItem in feed {
                Firestore.firestore().collection("feed").document(messageItem.id!).collection("comments").getDocuments { QuerySnapshot, Error in
                    if Error == nil {
                        guard let QuerySnapshot = QuerySnapshot?.documents else {return}
                        
                        let comment = QuerySnapshot.compactMap({try? $0.data(as: Comment.self)})
                        
                        let itemIndex = feed.firstIndex { item in
                            item.id == messageItem.id
                        }
                        if let index = itemIndex {
                            feed[index].comments = comment
                        }
                    }
                    completion(feed)
                }
            }
        }
    }
    
    func deleteFeed(messageId: String) async {
        do {
            _ = try await Firestore.firestore().collection("feed").document(messageId).delete()
        } catch {
            //self.errorMessage = setErrorMessage(errorCode: error)
        }
    }
    
    func convertPhoto(_ photoItem: PhotosPickerItem) async -> UIImage? {
        do{
            guard let imageData = try await photoItem.loadTransferable(type: Data.self) else {return nil}
            return UIImage(data: imageData)
        } catch {
        }
        return nil
    }
    
    
    
    func createNewMessage(photo: PhotosPickerItem?, message: MessageFeed) async {
        var newMessage = message
        do{
            if photo != nil {
                guard let imageData = try await photo?.loadTransferable(type: Data.self) else {return}
                let storageRef = Storage.storage().reference().child("feed_images").child("\(UUID())")
                _ = try await storageRef.putDataAsync(imageData)
                let downloadURL = try await storageRef.downloadURL()
                newMessage.feed_media = downloadURL.absoluteString
                _ = try Firestore.firestore().collection("feed").addDocument(from: newMessage)
            } else {
                _ = try  Firestore.firestore().collection("feed").addDocument(from: newMessage)
            }
        } catch{
        }
    }
}
