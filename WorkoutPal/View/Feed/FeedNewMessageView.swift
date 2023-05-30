//
//  FeedNewMessageView.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 5/24/23.
//

import SwiftUI
import _PhotosUI_SwiftUI

struct FeedNewMessageView: View {
    @EnvironmentObject var userModel:UserDataModel
    @EnvironmentObject var feedModel:FeedDataModel
    
    @State var feedMessage:String = ""
    @Binding var viewState:Bool
    var body: some View {
        VStack{
            HStack{
                Text("@\(userModel.userHandle)")
            }.frame(maxWidth: .infinity,alignment: .leading)
            
            PhotosPicker(selection: $feedModel.feedPhotoPickerItem, matching: .images) {
                if feedModel.feedUIImage == nil {
                    Image(systemName: "pencil")
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
            
            TextField("Message",text: $feedMessage)
            
            Button {
                Task{
                    await feedModel.createNewMessage(message: MessageFeed(id: "", body: feedMessage, authorId: userModel.userHandle))
                }
                viewState = false
            } label: {
                Text("Post")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
        }
        .alert(feedModel.errorMessage, isPresented: $feedModel.isError, actions: {})
        .padding()
    }
}
