//
//  FeedDataModel.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 5/23/23.
//

import Foundation
import Firebase
import FirebaseAuth

class FeedDataModel: ObservableObject {
    
    
    @Published var feedArr: [MessageFeed] = []
    @Published var forYouArr: [MessageFeed] = []
    @Published var yourPost:[MessageFeed] = []
    @Published var isError: Bool = false
    @Published var errorMessage: String = ""
    
    init(){
        //createNewMessage(message: MessageFeed(id: "", body: "This is a test", authorId: "adasdadsa"))
        //createNewMessage(message: MessageFeed(id: "", body: "This is a test", authorId: "adasdadsa"))
        //createNewMessage(message: MessageFeed(id: "", body: "This is a test", authorId: "adasdadsa"))
        
        //fetchAllMessages()
        updateFetch()
    }
    
    func setErrorMessage(errorCode: Error) -> String{
        self.isError = true
        return errorCode.localizedDescription
    }
    
    func updateFetch(){
        let dbRef = Firestore.firestore().collection("feed").addSnapshotListener { QuerySnapshot, Error in
            if Error == nil{
                if let snapShot = QuerySnapshot{
                    self.feedArr = []
                    for doc in snapShot.documents{
                        let data = doc.data()
                        
                        let feedId = doc.documentID
                        let feedBody = data["feed_body"] as! String
                        let feedAuthor = data["feed_author_id"] as! String
                        let feedTimestamp = data["feed_timestamp"] as! Timestamp
                        
                        self.feedArr.append(MessageFeed(id: feedId, body: feedBody, authorId: feedAuthor, date: feedTimestamp))
                    }
                }
            }else{
                self.errorMessage = setErrorMessage(errorCode: Error)
            }
        }
        if Auth.auth().currentUser == nil {
            dbRef.remove()
        }
    }
    
    func fetchAllMessages(){
        self.feedArr = []
        let db = Firestore.firestore()
        let collection = db.collection("feed")
        collection.getDocuments { SnapShot, Error in
            if Error != nil {
                self.errorMessage = setErrorMessage(errorCode: Error)
            }else if let snapShot = SnapShot {
                for doc in snapShot.documents{
                    let data = doc.data()
                    
                    let feedId = doc.documentID
                    let feedBody = data["feed_body"] as! String
                    let feedAuthor = data["feed_author_id"] as! String
                    let feedTimestamp = data["feed_timestamp"] as! Timestamp
                    
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
        
        let dbRef = Firestore.firestore().collection("feed").addDocument(data: ["feed_body":message.body,"feed_author_id":message.authorId, "feed_timestamp":message.date], completion: { Error in
            if let error = Error{
                self.errorMessage = self.setErrorMessage(errorCode: error)
            }
        })
    }
}

