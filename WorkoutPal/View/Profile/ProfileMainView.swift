//
//  ProfileMainView.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 5/23/23.
//

import SwiftUI

struct ProfileMainView: View {
    @EnvironmentObject var model: DataModel
    @EnvironmentObject var userModel: UserDataModel
    var body: some View {
        VStack {
            ProfileHeaderComp()
            Divider()
            ProfileYourPostView(userHandle: userModel.userInfo.user_handle)
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
