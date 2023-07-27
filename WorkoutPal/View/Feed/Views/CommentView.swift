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
    @EnvironmentObject var feedModel: FeedViewModel
    @State var newCommentViewState = false
    let post: MessageFeed
    var body: some View {
        NavigationView {
            VStack {
                PostView(postItem: post)
                    .padding(.horizontal)
                Divider()
                if let comments = post.comments{
                    ScrollView{
                        LazyVStack{
                            ForEach(comments) { comment in
                                CommentComponent(comment: comment)
                            }
                        }
                    }} else {
                        Text("No Comments")
                    }
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
