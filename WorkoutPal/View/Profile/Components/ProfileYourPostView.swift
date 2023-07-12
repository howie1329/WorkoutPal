//
//  ForYouFeedView.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 5/23/23.
//

import SwiftUI

/// View that shows only the users post
struct ProfileYourPostView: View {
    @State var userID: String
    @EnvironmentObject var feedModel: FeedViewModel
    var body: some View {
        ScrollView{
            LazyVStack{
                ForEach(feedModel.yourPost) {item in
                    PostView(postItem: item)
                    /// TODO: Swipe Action does not work
                    .swipeActions {
                        Button(role: .destructive) {
                            Task {
                                await feedModel.deleteMessage(item.id!)
                            }
                        } label: {
                            Image(systemName: "minus.circle")
                        }
                    }
                }
            }
        }
        .refreshable {
            /// Pull down refresh
            feedModel.sortFeedMessages(userID: userID)
        }
        .onAppear(perform: {
            /// To be done when view first appears
            feedModel.sortFeedMessages(userID: userID)
        })
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}

struct ProfileYourPostView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileYourPostView(userID: "")
            .environmentObject(FeedViewModel())
    }
}
