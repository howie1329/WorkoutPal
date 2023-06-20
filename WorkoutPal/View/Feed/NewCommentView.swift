//
//  NewCommentView.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 6/9/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct NewCommentView: View {
    @EnvironmentObject var userModel:UserDataModel
    @EnvironmentObject var feedModel:FeedDataModel
    
    let orignalMessage: MessageFeed
    @State var commentMessage:String = ""
    @Binding var viewState:Bool
    
    var body: some View {
        NavigationView{
            VStack{
                HStack{
                    WebImage(url: URL(string: userModel.userUrl)).placeholder(content: {
                        Circle().fill(.black)
                            .frame(width:50, height: 50)
                            .cornerRadius(100)
                    })
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width:50, height: 50)
                    .cornerRadius(100)
                    .clipped()
                    
                    Text("@\(userModel.userHandle)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.leading,.top])
                HStack{
                    TextField("Comment", text: $commentMessage)
                }
                .frame(maxWidth:.infinity, alignment: .leading)
                .padding(.horizontal)
                Spacer()
            }
            .toolbar {
                Button {
                    Task{
                        await feedModel.createComment(newComment: Comment(id: "", authorId: userModel.userHandle, body: commentMessage, authorProfileURL: userModel.userUrl) ,oringalMessage: orignalMessage)
                    }
                    viewState = false
                } label: {
                    Text("Comment")
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
}
