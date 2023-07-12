//
//  FeedMessage.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 5/29/23.
//

import Foundation
import Firebase
import PhotosUI
import FirebaseFirestoreSwift

struct Comment: Codable, Identifiable {
    @DocumentID var id: String?
    var author_Id: String
    var author_handle: String
    var message: String
    var author_Url: String
    var date = Timestamp(date: Date.now)
}

struct MessageFeed: Codable, Identifiable {
    @DocumentID var id: String?
    var feed_body: String
    var feed_author_id: String
    var feed_author_handle: String
    var feed_author_url: String
    var feed_media: String?
    var comments: [Comment]?
    var feed_like_count: Int = 0
    var feed_timestamp = Timestamp(date: Date.now)
}
