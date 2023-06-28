//
//  Service.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 5/10/23.
//

import Foundation

enum loadingState{
    case loading
    case success
}

func findTotalCal(protien:Int, fats: Int, carbs: Int) -> Int{
    var totalCalories = 0
    totalCalories += (protien * 4)
    totalCalories += (carbs * 4)
    totalCalories += (fats * 4)
    
    return totalCalories
}

func getWeekStats(currentDate: Date, foodItem: [FoodItemEntity], dayStats: [DayLogEntity]) -> weekModel{
    var dayLogArr: [dayModel] = []
    var weekArr: [dayModel] = []
    var totalCarbs = 0
    var totalFats = 0
    var totalProtien = 0
    var totalCal = 0
    var start = true
    var mod = -3
    
    let currentWeekNumber = currentDate.findWeekNumber()
    
    for logItem in dayStats{
        if logItem.date?.findWeekNumber() == currentWeekNumber {
            let stats = getDayStats(currentDate: logItem.date!, foodItems: foodItem, day: dayStats)
            weekArr.append(stats)
        }
    }
    
    for info in weekArr{
        totalCal += Int(info.totalCal)
        totalFats += Int(info.fats)
        totalProtien += Int(info.protein)
        totalCarbs += Int(info.carbs)
    }
    
    return weekModel(totalCal: totalCal, protein: totalProtien, carbs: totalCarbs, fats: totalFats, dayInfo: weekArr)
   
    
    while start {
        if mod == 0{
            mod += 1
        }
        let day = currentDate.addingTimeInterval(TimeInterval(mod))
        print(day)
        let model = getDayStats(currentDate: day, foodItems: foodItem, day: dayStats)
        weekArr.append(model)
        mod += 1
        if mod == 7 {
            start = false
        }
        
        
        
       
    }
}

func getDayStats(currentDate: Date, foodItems:[FoodItemEntity], day: [DayLogEntity]) -> dayModel{
    var dayInfo: [FoodItemEntity] = []
    for item in foodItems {
        if item.date?.formatted(date: .numeric, time: .omitted) == currentDate.formatted(date: .numeric, time: .omitted){
            dayInfo.append(item)
        }
            
    }
    
    let dayitem = day.first { DayLogEntity in
        DayLogEntity.date?.formatted(date: .numeric, time: .omitted) == currentDate.formatted(date: .numeric, time: .omitted)
    }
    
    
    var totalCarbs = 0
    var totalFats = 0
    var totalProtien = 0
    var totalCal = 0
    
    for info in dayInfo{
        totalCal += Int(info.totalCal)
        totalFats += Int(info.fat)
        totalProtien += Int(info.protien)
        totalCarbs += Int(info.carb)
    }
    
    return dayModel(totalCal: totalCal, date: currentDate, protein: totalProtien, carbs: totalCarbs, fats: totalFats, isCompleted: dayitem?.isWorkoutCompleted ?? false)
    
    
}
