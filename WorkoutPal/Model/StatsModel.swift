//
//  StatsModel.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 6/24/23.
//

import Foundation

struct DayModel: Identifiable {
    var id = UUID()
    var totalCal: Int
    var stringDate: String {
        return self.date.formatted(date: .numeric, time: .omitted)
    }
    var weekNumber: Int {
        return self.date.findWeekNumber()
    }
    var date: Date
    var protein: Int
    var carbs: Int
    var fats: Int
    var isCompleted: Bool
}

struct WeekModel: Identifiable {
    var id = UUID()
    var totalCal: Int
    var protein: Int
    var carbs: Int
    var fats: Int
    var dayInfo: [DayModel]
}
