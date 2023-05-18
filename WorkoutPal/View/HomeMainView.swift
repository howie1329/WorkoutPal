//
//  HomeMainView.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 5/10/23.
//

import SwiftUI

struct HomeMainView: View {
    @EnvironmentObject var model:DataModel
    @State var weekStats = (0,0,0,0)
    var body: some View {
        NavigationStack{
            VStack{
                Text("Today is \(model.currentDate.formatted(date: .abbreviated, time: .omitted)) Week: \(model.weekNumber)")
                Text("\(weekStats.0) cals \(weekStats.1)g protien \(weekStats.2)g carbs \(weekStats.3)g fat")
                HomeScrollView()
            }
            .onAppear(perform: {
                weekStats = gatherWeekCalStats(currentDay: model.currentDate, mealsArr: model.calorieTrackerLog)
            })
            .navigationTitle("Workout Pal")
            Spacer()
        }
    }
}

struct HomeMainView_Previews: PreviewProvider {
    static var previews: some View {
        HomeMainView()
            .environmentObject(DataModel())
    }
}
