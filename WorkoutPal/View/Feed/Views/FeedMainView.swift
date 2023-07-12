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
    @EnvironmentObject var feedModel: FeedViewModel
    @State var newMessageViewState = false
    @State var explorePageViewState = false
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("Workout Circle")
                        .font(.title)
                        .bold()
                    Spacer()
                    HStack(spacing:20){
                        FeedMainHeader(explorePageViewState: $explorePageViewState)
                        NavigationLink {
                            ProfileMainView()
                        } label: {
                            WebImage(url: URL(string: userModel.userInfo.user_profileURL )).placeholder(content: {
                                Circle()
                                    .fill(.black)
                                    .frame(width: 35, height: 35)
                                    .cornerRadius(100)
                                    .clipped()
                            })
                            .resizable()
                            .frame(width: 35, height: 35)
                            .cornerRadius(100)
                            .clipped()
                        }
                    }
                }
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .leading)
                Divider()
                ForYouFeedView(userID: userModel.userInfo.user_id)
                    .overlay(alignment: .bottomTrailing) {
                        Button {
                            newMessageViewState = true
                        } label: {
                            ZStack {
                                Circle().frame(width: 56, height: 56)
                                Image(systemName: "plus")
                                    .bold()
                                    .foregroundColor(.white)
                            }
                        }.padding([.bottom,.trailing])
                    }
                 
            }
        }
        .navigationTitle("PAL")
        .sheet(isPresented: $newMessageViewState) {
            FeedNewMessageView(viewState: $newMessageViewState)
                .presentationDetents([.medium, .large])
        }
        .sheet(isPresented: $explorePageViewState) {
           ExploreView()
        }
    }
}

struct FeedMainView_Previews: PreviewProvider {
    static var previews: some View {
        FeedMainView()
            .environmentObject(DataModel())
            .environmentObject(UserDataModel())
            .environmentObject(FeedViewModel())
    }
}
