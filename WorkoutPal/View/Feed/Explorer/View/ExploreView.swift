//
//  ExploreView.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 7/11/23.
//

import SwiftUI

struct ExploreView: View {
    @StateObject var exploreModel = ExploreViewModel()
    var body: some View {
        NavigationStack{
            VStack{
                ScrollView{
                    LazyVStack{
                        ForEach(exploreModel.searchableUsers, id: \.user_handle){userItem in
                            NavigationLink {
                                ExploreProfileView(searchUser: userItem)
                            } label: {
                                ExploreRowComponent(user: userItem)
                                    .tint(.white)
                            }
                            
                        }
                    }.searchable(text: $exploreModel.searchBar)
                }
            }
            .navigationTitle("Explore")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView()
    }
}
