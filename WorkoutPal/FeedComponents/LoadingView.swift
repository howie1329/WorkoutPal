//
//  LoadingView.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 5/29/23.
//

import SwiftUI

/// View To Be Displayed When View Is Loading
struct LoadingView: View {
    @EnvironmentObject var userModel: UserDataModel
    var body: some View {
        ZStack {
            VStack {
                ProgressView()
                    .animation(.easeIn(duration: 0.25), value: true)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
            .environmentObject(UserDataModel())
    }
}
