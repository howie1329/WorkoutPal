//
//  FeedMessage.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 5/29/23.
//

import Foundation
import Firebase

struct MessageFeed: Identifiable{
    
    var id:String
    var body:String
    var authorId:String
    var date = Timestamp(date: Date.now)

}
