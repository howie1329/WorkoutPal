//
//  Service.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 5/10/23.
//

import Foundation

enum LoadingState {
    case loading
    case success
}

func findTotalCal(protien: Int, fats: Int, carbs: Int) -> Int {
    var totalCalories = 0
    totalCalories += (protien * 4)
    totalCalories += (carbs * 4)
    totalCalories += (fats * 4)
    return totalCalories
}

func getWeekStats(currentDate: Date, foodItem: [FoodItemEntity], dayStats: [DayLogEntity]) -> WeekModel {
    var weekArr: [DayModel] = []
    var totalCarbs = 0
    var totalFats = 0
    var totalProtien = 0
    var totalCal = 0
    let currentWeekNumber = currentDate.findWeekNumber()
    for logItem in dayStats where logItem.date?.findWeekNumber() == currentWeekNumber {
        let stats = getDayStats(currentDate: logItem.date!, foodItems: foodItem, day: dayStats)
        weekArr.append(stats)
    }
    for info in weekArr {
        totalCal += Int(info.totalCal)
        totalFats += Int(info.fats)
        totalProtien += Int(info.protein)
        totalCarbs += Int(info.carbs)
    }
    return WeekModel(totalCal: totalCal, protein: totalProtien, carbs: totalCarbs, fats: totalFats, dayInfo: weekArr)
}

func getDayStats(currentDate: Date, foodItems: [FoodItemEntity], day: [DayLogEntity]) -> DayModel {
    var dayInfo: [FoodItemEntity] = []
    for item in foodItems where item.date?.formatted(date: .numeric, time: .omitted) == currentDate.formatted(date: .numeric, time: .omitted) {
        dayInfo.append(item)
    }
    let dayitem = day.first { DayLogEntity in
        DayLogEntity.date?.formatted(date: .numeric, time: .omitted) == currentDate.formatted(date: .numeric, time: .omitted)
    }
    var totalCarbs = 0
    var totalFats = 0
    var totalProtien = 0
    var totalCal = 0
    for info in dayInfo {
        totalCal += Int(info.totalCal)
        totalFats += Int(info.fat)
        totalProtien += Int(info.protien)
        totalCarbs += Int(info.carb)
    }
    return DayModel(totalCal: totalCal, date: currentDate, protein: totalProtien, carbs: totalCarbs, fats: totalFats, isCompleted: dayitem?.isWorkoutCompleted ?? false)
}
