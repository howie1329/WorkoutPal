//
//  WeekView.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 7/9/23.
//

import SwiftUI
import Charts

struct WeekView: View {
    @State var model: DataModel
    @State var weekStats: WeekModel
    var body: some View {
        Text("Today is \(model.currentDate.formatted(date: .abbreviated, time: .omitted))")
        Text("\(weekStats.totalCal) cals \(weekStats.protein)g protein \(weekStats.carbs)g carbs \(weekStats.fats)g fat")
        Divider()
        Chart {
            ForEach(model.dayLogTrackerLog) {item in
                if item.date?.findWeekNumber() == model.weekNumber {
                    BarMark(x: .value("Day", (item.date?.formatted(date: .numeric, time: .omitted))!),
                             y: .value("Calories", item.totalCal))
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 200)
        .padding()
    }
}
