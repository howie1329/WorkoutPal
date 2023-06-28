//
//  HomeStatsView.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 5/19/23.
//

import SwiftUI

struct HomeStatsView: View {
    @EnvironmentObject var model: DataModel
    @State var weekData: WeekModel
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(weekData.dayInfo) {item in
                    StatsRectangleView(itemData: item)
                }
            }
        }
        .onChange(of: model.currentDate) { _ in
            weekData = getWeekStats(currentDate: model.currentDate, foodItem: model.foodItemTrackerLog, dayStats: model.dayLogTrackerLog)
        }
    }
}
