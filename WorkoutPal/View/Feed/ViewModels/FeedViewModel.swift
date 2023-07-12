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

class FeedViewModel: ObservableObject {
    let placeholderArr: [MessageFeed] = [
        MessageFeed(id: "", feed_body: "", feed_author_id: "", feed_author_url: "", feed_media: "", comments: [], feed_like_count: 0)
    ]
    @Published var feedArr: [MessageFeed] = []
    @Published var forYouArr: [MessageFeed] = []
    @Published var yourPost: [MessageFeed] = []
    @Published var isError: Bool = false
    @Published var errorMessage: String = ""
    @Published var isLoading: LoadingState = .loading
    
    let feedService = FeedService()
    init() {
        fetchFeed()
    }
    
    func fetchFeed(){
        feedService.fetchFeed { messages in
            self.feedArr = []
            self.isLoading = .loading
            self.feedArr.append(contentsOf: messages)
            self.isLoading = .success
        }
    }
    
    @MainActor
    func deleteMessage(_ Id: String) async{
        await feedService.deleteFeed(messageId: Id)
    }
    
    // Service Code
    func setErrorMessage(errorCode: Error) -> String {
        self.isError = true
        return errorCode.localizedDescription
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
}
