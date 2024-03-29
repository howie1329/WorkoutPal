//
//  FeedNewMessageView.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 5/24/23.
//

import SwiftUI
import _PhotosUI_SwiftUI
import SDWebImageSwiftUI

struct FeedNewMessageView: View {
    @EnvironmentObject var userModel: UserDataModel
    @StateObject var newMessageModel = NewMessageViewModel()
    @State var feedMessage: String = ""
    @Binding var viewState: Bool
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    // MARK: Creators Profile Picture
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
                    Text("\(userModel.userInfo.user_name)")
                        .font(.subheadline)
                        .bold()
                    Text("@\(userModel.userInfo.user_handle)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }.frame(maxWidth: .infinity, alignment: .leading)
                PhotosPicker(selection: $newMessageModel.feedPhotoPickerItem, matching: .images) {
                    if newMessageModel.feedUIImage == nil {
                        Image(systemName: "photo.artframe")
                            .resizable()
                            .frame(maxWidth: 100, maxHeight: 100)
                            .foregroundColor(Color(.systemGray6))
                    } else {
                        if let image = newMessageModel.feedUIImage {
                            Image(uiImage: image)
                                .resizable()
                                .frame(maxWidth: 100, maxHeight: 100)
                                .clipped()
                        }
                    }
                }.onChange(of: newMessageModel.feedPhotoPickerItem) { _ in
                    Task {
                        await newMessageModel.convertImage()
                    }
                }
                TextField("What's happening?", text: $feedMessage)
                Spacer()
            }
            .toolbar {
                ToolbarItem {
                    Button {
                        Task {
                            let message = MessageFeed(id: "", feed_body: feedMessage, feed_author_id: userModel.userInfo.id!, feed_author_handle: userModel.userInfo.user_handle, feed_author_url: userModel.userInfo.user_profileURL, feed_like_count: 0)
                            await newMessageModel.uploadMessage(_: message)
                        }
                        viewState = false
                    } label: {
                        Text("Post")
                            .bold()
                            .padding(.horizontal, 6)
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding()
        }
    }
}
