//
//  PostView.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 5/29/23.
//

import SwiftUI
import SDWebImageSwiftUI

/// A Singluar post component
struct PostView: View {
    @EnvironmentObject var userModel: UserDataModel
    let postItem: MessageFeed
    var body: some View {
        VStack {
            HStack {
                // MARK: Creators Profile Picture
                if let url = postItem.authorProfileURL {
                    WebImage(url: URL(string: url)).placeholder(content: {
                        Circle().fill(.black)
                            .frame(width: 50, height: 50)
                            .cornerRadius(100)
                    })
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .cornerRadius(100)
                    .clipped()
                } else {
                    Circle().fill(.black)
                        .frame(width: 50, height: 50)
                        .cornerRadius(100)
                }
                Text("@\(postItem.authorId)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            VStack(spacing: 20) {
                HStack {
                    Text(postItem.body)
                    if let image = postItem.mediaURL {
                        WebImage(url: URL(string: image))
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: .infinity, maxHeight: 200)
                            .clipped()
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                HStack {
                    if userModel.userLikedPost.contains(postItem.id) {
                        Image(systemName: "heart.fill")
                            .resizable()
                            .frame(width: 13, height: 13)
                            .foregroundColor(.red)
                    } else {
                        Image(systemName: "heart")
                            .resizable()
                            .frame(width: 13, height: 13)
                            .foregroundColor(.gray)
                    }
                    Text("\(postItem.likeCounter)")
                        .font(.caption2)
                        .foregroundColor(.gray)
                    Image(systemName: "message")
                        .resizable()
                        .frame(width: 13, height: 13)
                        .foregroundColor(.gray)
                    Text("\(postItem.comments.count)")
                        .font(.caption2)
                        .foregroundColor(.gray)
                    Spacer()
                    Text("\(postItem.date.dateValue().formatted(date: .abbreviated, time: .shortened))")
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .swipeActions {
            if userModel.userLikedPost.contains(postItem.id) {
                Button {
                    userModel.removeLike(post: postItem)
                } label: {
                    Image(systemName: "heart.slash.fill")
                        .foregroundColor(.red)
                }
                .tint(.red)
            } else {
                Button {
                    userModel.likePost(post: postItem)
                } label: {
                    Image(systemName: "heart.fill")
                }
                .tint(.red)
            }
        }
    }
}
