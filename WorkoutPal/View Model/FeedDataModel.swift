//
//  FeedDataModel.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 5/23/23.
//

import Foundation
import Firebase
import FirebaseAuth
import _PhotosUI_SwiftUI
import FirebaseStorage

class FeedDataModel: ObservableObject {
    
    @Published var feedArr: [MessageFeed] = []
    @Published var forYouArr: [MessageFeed] = []
    @Published var yourPost:[MessageFeed] = []
    @Published var isError: Bool = false
    @Published var errorMessage: String = ""
    @Published var feedPhotoPickerItem: PhotosPickerItem? = nil
    @Published var feedUIImage: UIImage? = nil
    
    init(){
        updateFetch()
    }
    
    @MainActor
    func convertPhoto() async {
        do{
            guard let imageData = try await feedPhotoPickerItem?.loadTransferable(type: Data.self) else {return}
            self.feedUIImage = UIImage(data: imageData)
        }catch{
            print(error)
        }
    }
    
    func setErrorMessage(errorCode: Error) -> String{
        self.isError = true
        return errorCode.localizedDescription
    }
    
    @MainActor
    func deleteMessage(messageId: String) async {
        do{
            let index = forYouArr.firstIndex { MessageFeed in
                messageId == MessageFeed.id
            }
            if let index = index{
                forYouArr.remove(at: index)
                
            }
            let _ = try await Firestore.firestore().collection("feed").document(messageId).delete()
        } catch {
            self.errorMessage = setErrorMessage(errorCode: error)
        }
        
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
                        let feedMedia = data["feed_media"] as? String
                        let feedAuthorURL = data["feed_author_url"] as? String
                        
                        self.feedArr.append(MessageFeed(id: feedId, body: feedBody, authorId: feedAuthor, authorProfileURL: feedAuthorURL, mediaURL: feedMedia ,date: feedTimestamp))
                    }
                }
            }else if let Error = Error{
                self.errorMessage = self.setErrorMessage(errorCode: Error)
            }
        }
        if Auth.auth().currentUser == nil {
            dbRef.remove()
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
    
    func createNewMessage(message: MessageFeed) async {
        
        do{
            if feedPhotoPickerItem != nil{
                
                guard let imageData = try await self.feedPhotoPickerItem?.loadTransferable(type: Data.self) else {return}
                
                
                let storageRef = Storage.storage().reference().child("feed_images").child("\(UUID())")
                let _ = try await storageRef.putDataAsync(imageData)
                let downloadURL = try await storageRef.downloadURL()
                
                _ = Firestore.firestore().collection("feed").addDocument(data: ["feed_body":message.body,"feed_author_id":message.authorId,"feed_author_url":message.authorProfileURL, "feed_timestamp":message.date, "feed_media": downloadURL.absoluteString], completion: { Error in
                    if let error = Error{
                        self.errorMessage = self.setErrorMessage(errorCode: error)
                    }
                })
            } else {
                
                _ = Firestore.firestore().collection("feed").addDocument(data: ["feed_body":message.body,"feed_author_id":message.authorId, "feed_author_url":message.authorProfileURL, "feed_timestamp":message.date], completion: { Error in
                    if let error = Error{
                        self.errorMessage = self.setErrorMessage(errorCode: error)
                    }
                })
            }
            
        } catch {
            self.errorMessage = self.setErrorMessage(errorCode: error)
        }
        
        
    }
}

