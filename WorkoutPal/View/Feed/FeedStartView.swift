//
//  FeedStartView.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 5/22/23.
//

import SwiftUI

struct FeedStartView: View {
    @EnvironmentObject var userModel: UserDataModel
    var body: some View {
        VStack {
            if userModel.appState == .signedOut {
                OnboardingSelectionView()
            } else if userModel.appState == .signedIn {
                FeedMainView()
            }
        }
        .onAppear(perform: {
            userModel.checkLogin()
        })
    }
}

struct FeedStartView_Previews: PreviewProvider {
    static var previews: some View {
        FeedStartView()
            .environmentObject(UserDataModel())
    }
}
