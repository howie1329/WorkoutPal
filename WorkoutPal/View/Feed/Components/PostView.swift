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
                WebImage(url: URL(string: postItem.feed_author_url)).placeholder(content: {
                    Circle().fill(.black)
                        .frame(width: 50, height: 50)
                        .cornerRadius(100)
                })
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 50, height: 50)
                .cornerRadius(100)
                .clipped()
                Text("@\(postItem.feed_author_handle)")
                    .font(.subheadline)
                    .bold()
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
                        .font(.subheadline)
                        .multilineTextAlignment(.leading)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                HStack {
                    Text("\(postItem.comments?.count ?? 0)")
                        .font(.caption2)
                        .foregroundColor(.gray)
                    Image(systemName: "message")
                        .resizable()
                        .frame(width: 18, height: 18)
                        .foregroundColor(.gray)
                    if postItem.feed_author_id != userModel.userInfo.id!{
                        LikeButton(item: postItem)
                    }
                    Spacer()
                    Text("\(postItem.feed_timestamp.dateValue().formatted(date: .abbreviated, time: .shortened))")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding()
    }
}
