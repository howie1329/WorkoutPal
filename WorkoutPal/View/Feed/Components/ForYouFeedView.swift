//
//  ForYouFeedView.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 5/23/23.
//

import SwiftUI

/// The feed the gets showed to the user which represents a "For You Feed"
struct ForYouFeedView: View {
    @State var userID: String
    @EnvironmentObject var userModel: UserDataModel
    @EnvironmentObject var feedModel: FeedViewModel
    var body: some View {
        ScrollView {
            switch feedModel.isLoading {
            case .loading:
                ForEach(feedModel.placeholderArr) {item in
                    PostView(postItem: item)
                        .redacted(reason: .placeholder)
                }
            case .success:
                LazyVStack{
                    ForEach(feedModel.forYouArr) {item in
                        NavigationLink {
                            CommentView(post: item)
                        } label: {
                            PostView(postItem: item)
                                .foregroundColor(.black)
                        }
                        Divider()
                        
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

struct ForYouFeedView_Previews: PreviewProvider {
    static var previews: some View {
        ForYouFeedView(userID: "")
            .environmentObject(FeedViewModel())
    }
}
