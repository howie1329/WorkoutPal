//
//  FeedDataModel.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 5/23/23.
//

import Foundation
import Firebase

class FeedDataModel: ObservableObject {
    
    
    @Published var feedArr: [MessageFeed] = []
    @Published var forYouArr: [MessageFeed] = []
    @Published var yourPost:[MessageFeed] = []
    
    init(){
        //createNewMessage(message: MessageFeed(id: "", body: "This is a test", authorId: "adasdadsa"))
        //createNewMessage(message: MessageFeed(id: "", body: "This is a test", authorId: "adasdadsa"))
        //createNewMessage(message: MessageFeed(id: "", body: "This is a test", authorId: "adasdadsa"))
        
        fetchAllMessages()
    }
    
    func fetchAllMessages(){
        self.feedArr = []
        let db = Firestore.firestore()
        let collection = db.collection("feed")
        collection.getDocuments { SnapShot, Error in
            if Error != nil {
                print("Error \(Error?.localizedDescription)")
            }else if let snapShot = SnapShot {
                for doc in snapShot.documents{
                    let data = doc.data()
                    
                    var feedId = doc.documentID
                    var feedBody = data["feed_body"] as! String
                    var feedAuthor = data["feed_author_id"] as! String
                    var feedTimestamp = data["feed_timestamp"] as! Timestamp
                    
                    self.feedArr.append(MessageFeed(id: feedId, body: feedBody, authorId: feedAuthor, date: feedTimestamp))
                }
            }
        }
    }
    
    func sortFeed(userHandle:String){
        var newArr: [MessageFeed] = []
        for item in feedArr{
            if item.authorId != userHandle {
                newArr.append(item)
            }
        }
        
        forYouArr = newArr
    }
    
    func sortYourPost(userHandle:String){
        var newArr:[MessageFeed] = []
        for item in feedArr{
            if item.authorId == userHandle{
                newArr.append(item)
            }
        }
        yourPost = newArr
    }
    
    func createNewMessage(message: MessageFeed){
        let db = Firestore.firestore()
        let collection = db.collection("feed")
        collection.addDocument(data: ["feed_body":message.body,"feed_author_id":message.authorId, "feed_timestamp":message.date])
    }
}

struct MessageFeed: Identifiable{
    
    var id:String
    var body:String
    var authorId:String
    var date = Timestamp(date: Date.now)
    
    
}
