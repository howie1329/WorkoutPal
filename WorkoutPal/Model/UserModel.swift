//
//  UserModel.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 7/11/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct UserModel: Codable, Identifiable {
    @DocumentID var id: String?
    var user_name: String
    var user_email: String
    var user_handle: String
    var user_gender: String
    var user_bio: String?
    var user_id: String
    var user_profileURL: String
    var liked_post: [String]
    var followed: [String]?
    var following: [String]?
}
