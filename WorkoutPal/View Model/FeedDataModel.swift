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
import FirebaseFirestoreSwift

class FeedDataModel: ObservableObject {
    let placeholderArr: [MessageFeed] = [
        MessageFeed(id: "", feed_body: "", feed_author_id: "", feed_author_url: "", feed_media: "", comments: [], feed_like_count: 0, userLike: false)
    ]
    @Published var feedArr: [MessageFeed] = []
    @Published var forYouArr: [MessageFeed] = []
    @Published var yourPost: [MessageFeed] = []
    @Published var isError: Bool = false
    @Published var errorMessage: String = ""
    @Published var feedPhotoPickerItem: PhotosPickerItem?
    @Published var feedUIImage: UIImage?
    @Published var isLoading: LoadingState = .loading
    init() {
        updateFetch()
    }
    // convert picker item to data
    @MainActor
    func convertPhoto() async {
        do {
            guard let imageData = try await feedPhotoPickerItem?.loadTransferable(type: Data.self) else {return}
            self.feedUIImage = UIImage(data: imageData)
        } catch {
            self.errorMessage = setErrorMessage(errorCode: error)
        }
    }
    // Service Code
    func setErrorMessage(errorCode: Error) -> String {
        self.isError = true
        return errorCode.localizedDescription
    }
    // Delete message
    // Need to also delete picture if not nil
    @MainActor
    func deleteMessage(messageId: String) async {
        do {
            let index = forYouArr.firstIndex { MessageFeed in
                messageId == MessageFeed.id
            }
            if let index = index {
                forYouArr.remove(at: index)
            }
            _ = try await Firestore.firestore().collection("feed").document(messageId).delete()
        } catch {
            self.errorMessage = setErrorMessage(errorCode: error)
        }
    }
    
    func updateFetch(){
        let dbRef = Firestore.firestore().collection("feed").order(by: "feed_timestamp",descending: true).addSnapshotListener { QuerySnapshot, Error in
            
            self.isLoading = .loading
            
            guard let documents = QuerySnapshot?.documents else {return}
            
            let finalFeedMessages = documents.compactMap({try? $0.data(as: MessageFeed.self)})
            
            for doc in finalFeedMessages {
                var mainMessage = doc
                Firestore.firestore().collection("feed").document(doc.id!).collection("comments").getDocuments { QuerySnapshot, _ in
                    
                    guard let something = QuerySnapshot?.documents else {return}
                    
                    mainMessage.comments = something.compactMap({try? $0.data(as: Comment.self)})
                    self.feedArr.append(mainMessage)
                }
            }
            self.isLoading = .success
        }
        if Auth.auth().currentUser == nil {
            dbRef.remove()
        }
    }
    
    func createComment(newComment: Comment, oringalMessage: MessageFeed){
        guard let feedID = oringalMessage.id else {return}
        let dbRef = Firestore.firestore().collection("feed").document(feedID).collection("comments").document()
        do{
            _ = try dbRef.setData(from: newComment)
        } catch{
            self.errorMessage = self.setErrorMessage(errorCode: error)
        }
    }
    /// Sort messages from feed array
    func sortFeedMessages(userHandle: String) {
        var youArr: [MessageFeed] = []
        var newFeedArr: [MessageFeed] = []
        for message in feedArr {
            if message.feed_author_id == userHandle {
                youArr.append(message)
            } else if message.feed_author_id != userHandle {
                newFeedArr.append(message)
            }
        }
        self.yourPost = youArr
        self.forYouArr = newFeedArr
    }
    
    func createNewMessage(message: MessageFeed) async{
        var newMessage = message
        do{
            if feedPhotoPickerItem != nil {
                guard let imageData = try await self.feedPhotoPickerItem?.loadTransferable(type: Data.self) else {return}
                let storageRef = Storage.storage().reference().child("feed_images").child("\(UUID())")
                _ = try await storageRef.putDataAsync(imageData)
                let downloadURL = try await storageRef.downloadURL()
                newMessage.feed_media = downloadURL.absoluteString
                _ = try Firestore.firestore().collection("feed").addDocument(from: newMessage)
            } else {
                _ = try  Firestore.firestore().collection("feed").addDocument(from: newMessage)
            }
        } catch{
            self.errorMessage = self.setErrorMessage(errorCode: error)
        }
    }
}
