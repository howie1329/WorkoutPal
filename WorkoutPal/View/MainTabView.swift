//
//  MainTabView.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 5/9/23.
//

import SwiftUI

struct MainTabView: View {
    @State var tabSelection = 1
    var body: some View {
        TabView(selection:$tabSelection){
            CalorieTrackerView()
                .tabItem {
                    Image(systemName: "fork.knife.circle.fill")
                    Text("Calorie Tracker")
                }.tag(0)
            HomeMainView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(1)
            WorkoutMainView()
                .tabItem {
                    Image(systemName: "dumbbell.fill")
                    Text("Workout")
                }.tag(2)
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
