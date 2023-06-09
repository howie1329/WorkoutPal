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
    let placeholderArr: [MessageFeed] = [
        MessageFeed(id: "", body: "adjasdksadbs", authorId: "Test Author", comments: []),
        MessageFeed(id: "", body: "adjasdksadbs", authorId: "Test Author", comments: []),
        MessageFeed(id: "", body: "adjasdksadbs", authorId: "Test Author", comments: []),
        MessageFeed(id: "", body: "adjasdksadbs", authorId: "Test Author", comments: []),
        MessageFeed(id: "", body: "adjasdksadbs", authorId: "Test Author", comments: [])
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
    // Method to look for new messages
    func updateFetch() {
        let dbRef = Firestore.firestore().collection("feed").order(by: "feed_timestamp", descending: true).addSnapshotListener { QuerySnapshot, Error in
            if Error == nil {
                if let snapShot = QuerySnapshot {
                    self.isLoading = .loading
                    self.feedArr = []
                    for doc in snapShot.documents {
                        let data = doc.data()
                        let feedId = doc.documentID
                        let feedBody = data["feed_body"] as! String
                        let feedAuthor = data["feed_author_id"] as! String
                        let feedTimestamp = data["feed_timestamp"] as! Timestamp
                        let feedMedia = data["feed_media"] as? String
                        let feedAuthorURL = data["feed_author_url"] as? String
                        let feedLikeCount  = data["feed_like_count"] as? Int ?? 0
                        let feedMessage = MessageFeed(id: feedId, body: feedBody, authorId: feedAuthor, authorProfileURL: feedAuthorURL, mediaURL: feedMedia, comments: [], likeCounter: feedLikeCount, date: feedTimestamp)
                        self.feedArr.append(feedMessage)
                    }
                    for messageItem in self.feedArr {
                        let id = messageItem.id
                        var commentArr: [Comment] = []
                        Firestore.firestore().collection("feed").document(id).collection("comments").getDocuments { QuerySnapshot, Error in
                            if Error == nil {
                                if let snapShot = QuerySnapshot {
                                    for doc in snapShot.documents {
                                        let data = doc.data()
                                        let commentId = doc.documentID
                                        let commentAuthor = data["author_Id"] as! String
                                        let commentMessage = data["message"] as! String
                                        let commentAuthorURL = data["author_Url"] as? String
                                        let commentDate = data["date"] as? Timestamp ?? Timestamp.init(date: Date.now)
                                        commentArr.append(Comment(id: commentId, authorId: commentAuthor, body: commentMessage, authorProfileURL: commentAuthorURL, date: commentDate))
                                        let index = self.feedArr.firstIndex { MessageFeed in
                                            MessageFeed.id == id
                                        }
                                        if let index = index {
                                            self.feedArr[index].comments = commentArr
                                        }
                                    }
                                }
                            }
                        }
                    }
                    self.isLoading = .success
                }
            } else if let Error = Error {
                self.errorMessage = self.setErrorMessage(errorCode: Error)
            }
        }
        if Auth.auth().currentUser == nil {
            dbRef.remove()
        }
    }
    func createComment(newComment: Comment, oringalMessage: MessageFeed) async {
        do {
            _ = try await Firestore.firestore().collection("feed").document(oringalMessage.id).collection("comments").document().setData(["author_Id": newComment.authorId, "message": newComment.body, "author_Url": newComment.authorProfileURL, "date": newComment.date])
        } catch {
            self.errorMessage = self.setErrorMessage(errorCode: error)
        }
    }
    /// Sort messages from feed array
    func sortFeedMessages(userHandle: String) {
        var youArr: [MessageFeed] = []
        var newFeedArr: [MessageFeed] = []
        for message in feedArr {
            if message.authorId == userHandle {
                youArr.append(message)
            } else if message.authorId != userHandle {
                newFeedArr.append(message)
            }
        }
        self.yourPost = youArr
        self.forYouArr = newFeedArr
    }
    // Create a new message
    func createNewMessage(message: MessageFeed) async {
        do {
            if feedPhotoPickerItem != nil {
                guard let imageData = try await self.feedPhotoPickerItem?.loadTransferable(type: Data.self) else {return}
                let storageRef = Storage.storage().reference().child("feed_images").child("\(UUID())")
                _ = try await storageRef.putDataAsync(imageData)
                let downloadURL = try await storageRef.downloadURL()
                _ = Firestore.firestore().collection("feed").addDocument(data: ["feed_body": message.body, "feed_author_id": message.authorId, "feed_author_url": message.authorProfileURL, "feed_timestamp": message.date, "feed_media": downloadURL.absoluteString, "feed_like_count": 0], completion: { Error in
                    if let error = Error {
                        self.errorMessage = self.setErrorMessage(errorCode: error)
                    }
                })
            } else {
                _ = Firestore.firestore().collection("feed").addDocument(data: ["feed_body": message.body, "feed_author_id": message.authorId, "feed_author_url": message.authorProfileURL, "feed_timestamp": message.date, "feed_like_count": 0], completion: { Error in
                    if let error = Error {
                        self.errorMessage = self.setErrorMessage(errorCode: error)
                    }
                })
            }
        } catch {
            self.errorMessage = self.setErrorMessage(errorCode: error)
        }
    }
}
