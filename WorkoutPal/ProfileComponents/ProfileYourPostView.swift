//
//  ForYouFeedView.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 5/23/23.
//

import SwiftUI

/// View that shows only the users post
struct ProfileYourPostView: View {
    @State var userHandle:String
    @EnvironmentObject var feedModel:FeedDataModel
    var body: some View {
        List{
            ForEach(feedModel.yourPost){item in
                PostView(postItem: item)
                .swipeActions {
                    Button(role:.destructive){
                        Task{
                            await feedModel.deleteMessage(messageId:item.id )
                        }
                    } label: {
                        Image(systemName: "minus.circle")
                    }
                    
                }
                
            }
        }
        .refreshable {
            // Pull down refresh
            feedModel.sortFeed(userHandle: userHandle)
            feedModel.sortYourPost(userHandle: userHandle)
        }
        .onAppear(perform: {
            // To be done when view first appears
            feedModel.sortFeed(userHandle: userHandle)
            feedModel.sortYourPost(userHandle: userHandle)
        })
        .frame(maxWidth: .infinity, maxHeight:.infinity, alignment:.top)
    }
}

struct ProfileYourPostView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileYourPostView(userHandle: "")
            .environmentObject(FeedDataModel())
    }
}
