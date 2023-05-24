//
//  FeedMainView.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 5/23/23.
//

import SwiftUI

struct FeedMainView: View {
    @EnvironmentObject var model:DataModel
    @EnvironmentObject var userModel:UserDataModel
    @EnvironmentObject var feedModel:FeedDataModel
    
    enum feedChoices: String,CaseIterable {
        case forYou = "For You"
        case following = "Following"
    }
    
    
    @State var feedChoiceSelection:feedChoices = .forYou
    @State var newMessageViewState = false
    
    var body: some View {
        NavigationStack{
            VStack{
                HStack{
                    NavigationLink {
                        ProfileMainView()
                    } label: {
                        Circle().frame(maxWidth: 50)
                    }
                }
                .padding(.horizontal)
                .frame(maxWidth: .infinity,alignment: .leading)
                Picker("", selection: $feedChoiceSelection) {
                    ForEach(feedChoices.allCases,id:\.self){item in
                        Text(item.rawValue.capitalized)
                    }
                }
                .pickerStyle(.segmented)
                if feedChoiceSelection == .forYou{
                    ForYouFeedView(userHandle: userModel.userHandle)
                    .overlay(alignment:.bottomTrailing){
                        Button {
                            newMessageViewState = true
                        } label: {
                            ZStack{
                                Circle().frame(maxWidth: 50)
                                Image(systemName: "plus")
                                    .bold()
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }else if feedChoiceSelection == .following{
                    VStack{
                        Text("Following")
                    }
                    .frame(maxWidth: .infinity, maxHeight:.infinity, alignment:.top)
                    .overlay(alignment:.bottomTrailing){
                        Button {
                            newMessageViewState = true
                        } label: {
                            ZStack{
                                Circle().frame(maxWidth: 50)
                                Image(systemName: "plus")
                                    .bold()
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.trailing)
                    }
                }
            }
            
        }
        .sheet(isPresented: $newMessageViewState) {
            FeedNewMessageView(viewState: $newMessageViewState)
                .presentationDetents([.medium])
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
