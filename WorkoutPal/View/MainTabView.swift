//
//  MainTabView.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 5/9/23.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            CalorieTrackerView()
                .tabItem {
                    Image(systemName: "fork.knife.circle.fill")
                    Text("Calorie Tracker")
                }
            WorkoutMainView()
                .tabItem {
                    Image(systemName: "dumbbell.fill")
                    Text("Workout")
                }
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
