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
                if let url = postItem.feed_author_url {
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
                Text("@\(postItem.feed_author_id)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            VStack(spacing: 20) {
                VStack {
                    if let image = postItem.feed_media {
                        WebImage(url: URL(string: image))
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: .infinity, maxHeight: 200)
                            .cornerRadius(20)
                            .clipped()
                    }
                    Text(postItem.feed_body)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                HStack {
                    /*if userModel.userLikedPost.contains(postItem.id) {
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
                    */
                    Text("\(postItem.feed_like_count)")
                        .font(.caption2)
                        .foregroundColor(.gray)
                    Image(systemName: "message")
                        .resizable()
                        .frame(width: 13, height: 13)
                        .foregroundColor(.gray)
                    /*Text("\(postItem.comments.count)")
                        .font(.caption2)
                        .foregroundColor(.gray) */
                    Spacer()
                    Text("\(postItem.feed_timestamp.dateValue().formatted(date: .abbreviated, time: .shortened))")
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(.horizontal)
    }
}
