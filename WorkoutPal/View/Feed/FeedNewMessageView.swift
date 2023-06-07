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
    @EnvironmentObject var userModel:UserDataModel
    @EnvironmentObject var feedModel:FeedDataModel
    
    @State var feedMessage:String = ""
    @Binding var viewState:Bool
    var body: some View {
        NavigationView{
            VStack{
                HStack{
                    // MARK: Creators Profile Picture
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
                }.frame(maxWidth: .infinity,alignment: .leading)
                
                PhotosPicker(selection: $feedModel.feedPhotoPickerItem, matching: .images) {
                    if feedModel.feedUIImage == nil {
                        Image(systemName: "photo.on.rectangle")
                            .resizable()
                            .frame(maxWidth: 50, maxHeight:50)
                    } else {
                        if let image = feedModel.feedUIImage{
                            Image(uiImage: image)
                                .resizable()
                                .frame(maxWidth: 50, maxHeight:50)
                                .clipped()
                        }
                    }
                }.onChange(of: feedModel.feedPhotoPickerItem) { newValue in
                    Task{
                        await feedModel.convertPhoto()
                    }
                }
                
                TextField("What's happening?",text: $feedMessage)
                Spacer()
                
            }
            .toolbar{
                ToolbarItem{
                    Button {
                        Task{
                            await feedModel.createNewMessage(message: MessageFeed(id: "", body: feedMessage, authorId: userModel.userHandle, authorProfileURL: userModel.userUrl))
                        }
                        viewState = false
                    } label: {
                        Text("Post")
                            .bold()
                            .padding([.horizontal])
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .alert(feedModel.errorMessage, isPresented: $feedModel.isError, actions: {})
            .padding()
        }
    }
}
