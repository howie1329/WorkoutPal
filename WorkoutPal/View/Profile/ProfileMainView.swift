//
//  ProfileMainView.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 5/23/23.
//

import SwiftUI

struct ProfileMainView: View {
    @EnvironmentObject var model:DataModel
    @EnvironmentObject var userModel:UserDataModel
    enum profileViewChoice: String,CaseIterable{
        case allPost = "Post"
        case mentions = "Mentions"
    }
    
    @State var profileViewSelection:profileViewChoice = .allPost
    
    var body: some View {
        VStack{
            ProfileHeaderComp(userHandle: userModel.userHandle)
            Picker("", selection: $profileViewSelection) {
                ForEach(profileViewChoice.allCases, id:\.self){item in
                    Text("\(item.rawValue.capitalized)")
                }
            }
            .pickerStyle(.segmented)
            if profileViewSelection == .allPost {
                ProfileYourPostView(userHandle: userModel.userHandle)
            }else if profileViewSelection == .mentions {
                Text("Mentions")
            }
        }
    }
}

struct ProfileMainView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileMainView()
            .environmentObject(DataModel())
            .environmentObject(UserDataModel())
    }
}
