//
//  FeedMessage.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 5/29/23.
//

import Foundation
import Firebase
import PhotosUI

struct MessageFeed: Identifiable{
    
    var id:String
    var body:String
    var authorId:String
    //var authorProfileURL: String
    var mediaURL: String?
    var date = Timestamp(date: Date.now)

}
