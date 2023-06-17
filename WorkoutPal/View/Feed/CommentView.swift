//
//  CommentView.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 6/9/23.
//

import SwiftUI

struct CommentView: View {
    @EnvironmentObject var userModel: UserDataModel
    @EnvironmentObject var feedModel: FeedDataModel
    
    @State var newCommentViewState = false
    let post : MessageFeed
    //let comments : [Comment]
    var body: some View {
        NavigationView{
            VStack{
                PostView(postItem: post)
                if post.comments.isEmpty{
                    Text("No Comments")
                    Spacer()
                }else{
                    List(post.comments) { comment in
                        VStack{
                            Text("@\(comment.authorId)")
                            Text(comment.body)
                        }
                    }}
            }
            .padding()
            .overlay(alignment:.bottomTrailing){
                Button {
                    newCommentViewState = true
                } label: {
                    ZStack{
                        Circle().frame(maxWidth: 50)
                        Image(systemName: "plus")
                            .bold()
                            .foregroundColor(.white)
                    }
                }.padding(.trailing)
            }
            .sheet(isPresented: $newCommentViewState) {
                NewCommentView(orignalMessage: post, viewState: $newCommentViewState)
            }
        }
    }
}
