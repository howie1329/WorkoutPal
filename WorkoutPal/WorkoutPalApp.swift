//
//  WorkoutPalApp.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 5/5/23.
//

import SwiftUI

@main
struct WorkoutPalApp: App {
    @StateObject var dataModel = DataModel()
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(dataModel)
                .preferredColorScheme(.dark)
        }
    }
}
