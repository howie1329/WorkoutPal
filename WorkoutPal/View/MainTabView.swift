//
//  MainTabView.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 5/9/23.
//

import SwiftUI

struct MainTabView: View {
    @State var tabSelection = 2
    var body: some View {
        TabView(selection:$tabSelection){
            FeedStartView()
                .tabItem {
                    Image(systemName: "figure.socialdance")
                    Text("Feed")
                }.tag(0)
            CalorieTrackerView()
                .tabItem {
                    Image(systemName: "fork.knife.circle.fill")
                    Text("Calorie Tracker")
                }.tag(1)
            HomeMainView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(2)
            WorkoutMainView()
                .tabItem {
                    Image(systemName: "dumbbell.fill")
                    Text("Workout")
                }.tag(3)
            testLogView()
                .tabItem {
                    Text("Debug")
                }.tag(4)
        }
    }
}

/*struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
} */
