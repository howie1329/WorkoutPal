//
//  FeedMessage.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 5/29/23.
//

import Foundation
import Firebase
import PhotosUI

struct Comment: Identifiable, Decodable {
    var id: String
    var authorId: String
    var body: String
}

struct MessageFeed: Identifiable{
    
    var id: String
    var body: String
    var authorId: String
    var authorProfileURL: String?
    var mediaURL: String?
    var comments : [Comment]
    var date = Timestamp(date: Date.now)

}
