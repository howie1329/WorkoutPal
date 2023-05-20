//
//  HomeMainView.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 5/10/23.
//

import SwiftUI
import Charts

struct HomeMainView: View {
    @EnvironmentObject var model:DataModel
    @State var weekStats = (0,0,0,0)
    var body: some View {
        NavigationStack{
            VStack{
                Text("Today is \(model.currentDate.formatted(date: .abbreviated, time: .omitted)) Week: \(model.weekNumber)")
                Text("\(weekStats.0) cals \(weekStats.1)g protien \(weekStats.2)g carbs \(weekStats.3)g fat")
                Divider()
                Chart{
                    ForEach(model.weekDayData,id:\.0){item in
                        LineMark(x: .value("Day", item.0),
                                 y: .value("Calories", item.1))
                    }
                }
                .frame(maxWidth:.infinity, maxHeight: 200)
                .padding()
                Divider()
                HomeScrollView()
                HomeStatsView()
                Spacer()
                Divider()
                NavigationLink {
                    //
                } label: {
                    Button{
                        model.workoutDataModel.createDayWorkout(day: model.currentDay)
                        model.updateWeekDayData()
                        model.saveData()
                    } label: {
                        Text("Did You Workout Today?")
                            .bold()
                    }
                    .buttonStyle(.borderedProminent)

                }
            }
            .onAppear(perform: {
                weekStats = gatherWeekCalStats(currentDay: model.currentDate, mealsArr: model.calorieDataModel.calorieTrackerLog)
                model.updateWeekDayData()
                model.saveData()
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
