//
//  FeedMessage.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 5/29/23.
//

import Foundation
import Firebase
import PhotosUI

struct Comment: Identifiable {
    var id: String
    var authorId: String
    var body: String
    var authorProfileURL: String?
    var date = Timestamp(date: Date.now)
}

struct MessageFeed: Identifiable {
    var id: String
    var body: String
    var authorId: String
    var authorProfileURL: String?
    var mediaURL: String?
    var comments: [Comment]
    var likeCounter: Int = 0
    var userLike: Bool = false
    var date = Timestamp(date: Date.now)

}
