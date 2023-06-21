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

func gatherDayCalStates(currentDay: Int, mealsArr: [CalorieTrackerEntity], dayWorkoutArr:[DayWorkoutEntity]) -> [(Int,Int,Int,Int,Int,Bool)]{
    
    var weekData: [(Int,Int,Int,Int,Int,Bool)] = []
    
    
    for day in currentDay-3...currentDay+3{
        var totalCal = 0
        var proteinCount = 0
        var carbCount = 0
        var fatCount = 0
        var workoutDayIsCompleted = false

        for workout in dayWorkoutArr{
            if workout.dayNumber == day{
                workoutDayIsCompleted = workout.isCompleted
            }
        }
        
        for item in mealsArr{
            if item.dayNumber == day {
                totalCal += Int(item.totalCal)
                proteinCount += Int(item.protien)
                carbCount += Int(item.carb)
                fatCount += Int(item.fat)
            }
        }
        
        weekData.append((day,totalCal,proteinCount,carbCount ,fatCount, workoutDayIsCompleted))
    }
    
    
    
    return weekData
}

func gatherWeekCalStats(currentDay: Date, mealsArr: [CalorieTrackerEntity]) -> (Int,Int,Int,Int){
    let weekNumber = currentDay.findWeekNumber()
    
    var totalCal = 0
    var proteinCount = 0
    var carbCount = 0
    var fatCount = 0
    
    for item in mealsArr{
        if item.weekNumber == weekNumber {
            totalCal += Int(item.totalCal)
            proteinCount += Int(item.protien)
            carbCount += Int(item.carb)
            fatCount += Int(item.fat)
        }
    }
    
    return (totalCal,proteinCount,carbCount ,fatCount)
}

