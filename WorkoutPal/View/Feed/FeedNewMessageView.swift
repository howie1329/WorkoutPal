//
//  FeedNewMessageView.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 5/24/23.
//

import SwiftUI

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
            
            TextField("Message",text: $feedMessage)
            
            Button {
                feedModel.createNewMessage(message: MessageFeed(id: "", body: feedMessage, authorId: userModel.userHandle))
                feedModel.fetchAllMessages()
                viewState = false
            } label: {
                Text("Post")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}
