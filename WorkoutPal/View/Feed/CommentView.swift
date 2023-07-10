//
//  CommentView.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 6/9/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct CommentView: View {
    @EnvironmentObject var userModel: UserDataModel
    @EnvironmentObject var feedModel: FeedDataModel
    @State var newCommentViewState = false
    let post: MessageFeed
    var body: some View {
        NavigationView {
            VStack {
                PostView(postItem: post)
                    .padding(.horizontal)
                Divider()
                if post.comments == nil {
                    Text("No Comments")
                    Spacer()
                } else {
                    List(post.comments!) { comment in
                        VStack {
                            HStack {
                                WebImage(url: URL(string: comment.author_Url ?? "" )).placeholder(content: {
                                    Circle()
                                        .fill(.black)
                                        .frame(width: 50, height: 50)
                                        .cornerRadius(100)
                                })
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 50, height: 50)
                                .cornerRadius(100)
                                .clipped()
                                Text("@\(comment.author_Id)")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            HStack {
                                Text(comment.message)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            HStack {
                                Text(comment.date.dateValue().formatted(date: .abbreviated, time: .shortened))
                            }
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .font(.caption2)
                            .foregroundColor(.gray)
                        }
                    }}
            }
            .overlay(alignment: .bottomTrailing) {
                Button {
                    newCommentViewState = true
                } label: {
                    ZStack {
                        Circle().frame(maxWidth: 50)
                        Image(systemName: "plus")
                            .bold()
                            .foregroundColor(.white)
                    }
                }.padding(.trailing)
            }
            .sheet(isPresented: $newCommentViewState) {
                NewCommentView(orignalMessage: post, viewState: $newCommentViewState)
                    .presentationDetents([.medium])
            }
            .alert(feedModel.errorMessage, isPresented: $feedModel.isError, actions: {})
        }
    }
}
