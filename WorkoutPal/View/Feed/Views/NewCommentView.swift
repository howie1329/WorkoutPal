//
//  NewCommentView.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 6/9/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct NewCommentView: View {
    @EnvironmentObject var userModel: UserDataModel
    var viewModel = NewCommentViewModel()
    let orignalMessage: MessageFeed
    @State var commentMessage: String = ""
    @Binding var viewState: Bool
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    WebImage(url: URL(string: userModel.userInfo.user_profileURL)).placeholder(content: {
                        Circle().fill(.black)
                            .frame(width: 50, height: 50)
                            .cornerRadius(100)
                    })
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .cornerRadius(100)
                    .clipped()
                    Text("@\(userModel.userInfo.user_handle)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.leading, .top])
                HStack {
                    TextField("Comment", text: $commentMessage)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                Spacer()
            }
            .toolbar {
                Button {
                    Task {
                        viewModel.createComment(newComment: Comment(id: "", author_Id: userModel.userInfo.id!, author_handle: userModel.userInfo.user_handle, message: commentMessage, author_Url: userModel.userInfo.user_profileURL), oringalMessage: orignalMessage)
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
