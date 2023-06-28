//
//  FeedMainView.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 5/23/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct FeedMainView: View {
    @EnvironmentObject var model: DataModel
    @EnvironmentObject var userModel: UserDataModel
    @EnvironmentObject var feedModel: FeedDataModel
    @State var newMessageViewState = false
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    NavigationLink {
                        ProfileMainView()
                    } label: {
                        WebImage(url: URL(string: userModel.userUrl )).placeholder(content: {
                            Circle()
                                .fill(.black)
                                .frame(width: 50, height: 50)
                                .cornerRadius(100)
                                .clipped()
                        })
                        .resizable()
                        .frame(width: 50, height: 50)
                        .cornerRadius(100)
                        .clipped()
                    }
                }
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .leading)
                ForYouFeedView(userHandle: userModel.userHandle)
                    .overlay(alignment: .bottomTrailing) {
                        Button {
                            newMessageViewState = true
                        } label: {
                            ZStack {
                                Circle().frame(maxWidth: 50)
                                Image(systemName: "plus")
                                    .bold()
                                    .foregroundColor(.white)
                            }
                        }.padding(.trailing)
                    }
            }
        }
        .sheet(isPresented: $newMessageViewState) {
            FeedNewMessageView(viewState: $newMessageViewState)
                .presentationDetents([.medium, .large])
        }
    }
}

struct FeedMainView_Previews: PreviewProvider {
    static var previews: some View {
        FeedMainView()
            .environmentObject(DataModel())
            .environmentObject(UserDataModel())
            .environmentObject(FeedDataModel())
    }
}
