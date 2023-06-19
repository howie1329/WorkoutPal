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
        VStack{
            HStack{
                HStack{
                    // MARK: Creators Profile Picture
                    if let url = postItem.authorProfileURL{
                        WebImage(url: URL(string: url)).placeholder(content: {
                            Circle().fill(.black)
                                .frame(width:50, height: 50)
                                .cornerRadius(100)
                        })
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width:50, height: 50)
                            .cornerRadius(100)
                            .clipped()
                    } else {
                        Circle().fill(.black)
                            .frame(width:50, height: 50)
                            .cornerRadius(100)
                    }
                    Text("@\(postItem.authorId)")
                }
                Spacer()
                VStack{
                    if userModel.userLikedPost.contains(postItem.id){
                        Button {
                            userModel.removeLike(post: postItem)
                        } label: {
                            Image(systemName: "heart.fill")
                                .foregroundColor(.red)
                        }
                    }else{
                        Button {
                            userModel.likePost(post: postItem)
                        } label: {
                            Image(systemName: "heart")
                        }
                    }

                    
                    Text("\(postItem.likeCounter)")
                }
                Text("\(postItem.date.dateValue().formatted(date: .abbreviated, time: .shortened))")
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth:.infinity,alignment: .leading)
            .font(.footnote.bold())
            .foregroundColor(.gray)
            
            if let image = postItem.mediaURL{
                WebImage(url: URL(string: image))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity,maxHeight: 200)
                    .clipped()
            }
            HStack{
                Text(postItem.body)
            }.frame(maxWidth:.infinity,alignment:.leading)
        }
        .swipeActions {
            if userModel.userLikedPost.contains(postItem.id){
                Button {
                    userModel.removeLike(post: postItem)
                } label: {
                    Image(systemName: "heart.slash.fill")
                        .foregroundColor(.red)
                }
                .tint(.red)
            }else{
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
