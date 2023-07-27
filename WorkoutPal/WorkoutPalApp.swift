//
//  WorkoutPalApp.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 5/5/23.
//

import Firebase
import SwiftUI

@main
struct WorkoutPalApp: App {
    @StateObject var dataModel = DataModel()
    @StateObject var userModel = UserDataModel()
    @StateObject var feedModel = FeedViewModel()
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(dataModel)
                .environmentObject(userModel)
                .environmentObject(feedModel)
                .preferredColorScheme(.dark)
        }
    }
}
