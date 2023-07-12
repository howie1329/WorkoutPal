//
//  LikeButton.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 7/11/23.
//

import SwiftUI

struct LikeButton: View {
    @EnvironmentObject var userModel: UserDataModel
    var item: MessageFeed
    var body: some View {
        if userModel.userInfo.liked_post.contains(item.id!) {
            Button {
                userModel.removeLike(post: item)
            } label: {
                HStack{
                    Text("\(item.feed_like_count)")
                        .font(.caption2)
                        .foregroundColor(.gray)
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                }
            }
            .tint(.red)
        } else {
            Button {
                userModel.likePost(post: item)
            } label: {
                HStack{
                    Text("\(item.feed_like_count)")
                        .font(.caption2)
                        .foregroundColor(.gray)
                    Image(systemName: "heart")
                }
            }
            .tint(.red)
        }
    }
}
