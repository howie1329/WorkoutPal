//
//  ForYouFeedView.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 5/23/23.
//

import SwiftUI

/// The feed the gets showed to the user which represents a "For You Feed"
struct ForYouFeedView: View {
    @State var userHandle:String
    @EnvironmentObject var feedModel:FeedDataModel
    var body: some View {
        List{
            ForEach(feedModel.forYouArr){item in
                PostView(postItem: item)
            }
        }
        .refreshable {
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

struct ForYouFeedView_Previews: PreviewProvider {
    static var previews: some View {
        ForYouFeedView(userHandle: "")
            .environmentObject(FeedDataModel())
    }
}
