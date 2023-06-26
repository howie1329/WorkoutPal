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
    @State var weekStats = weekModel(totalCal: 0, protein: 0, carbs: 0, fats: 0, dayInfo: [])
    var body: some View {
        NavigationStack{
            VStack{
                Text("Today is \(model.currentDate.formatted(date: .abbreviated, time: .omitted)) Week: \(model.weekNumber)")
                Text("\(weekStats.totalCal) cals \(weekStats.protein)g protien \(weekStats.carbs)g carbs \(weekStats.fats)g fat")
                Divider()
                Chart{
                    ForEach(model.dayLogTrackerLog){item in
                        if item.date?.findWeekNumber() == model.weekNumber{
                            BarMark(x: .value("Day", (item.date?.formatted(date: .numeric, time: .omitted))!),
                                     y: .value("Calories", item.totalCal))
                        }
                    }
                }
                .frame(maxWidth:.infinity, maxHeight: 200)
                .padding()
                Divider()
                if weekStats.dayInfo.isEmpty{
                    Text("No Data")
                }else{
                    VStack{
                        ScrollViewHome(weekStats: weekStats)
                        HomeStatsView(weekData: weekStats)
                    }.padding(.horizontal)
                }
                Spacer()
                Divider()
            }
            .onAppear(perform: {
                weekStats = getWeekStats(currentDate: model.currentDate, foodItem: model.foodItemTrackerLog, dayStats: model.dayLogTrackerLog)
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
