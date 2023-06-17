//
//  NewCommentView.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 6/9/23.
//

import SwiftUI

struct NewCommentView: View {
    @EnvironmentObject var userModel:UserDataModel
    @EnvironmentObject var feedModel:FeedDataModel
    
    let orignalMessage: MessageFeed
    @State var commentMessage:String = ""
    @Binding var viewState:Bool
    
    var body: some View {
        VStack{
            VStack{
                Text("@\(userModel.userHandle)")
                TextField("Comment", text: $commentMessage)
            }
            
            Button {
                Task{
                    await feedModel.createComment(newComment: Comment(id: "", authorId: userModel.userHandle, body: commentMessage) ,oringalMessage: orignalMessage)
                }
            } label: {
                Text("Comment")
            }
        }
    }
}
