//
//  Service.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 5/10/23.
//

import Foundation

//MARK: Service Code
/// -- TODO: Need to move to own file

enum CalanderErrors: Error {
    case noConvertMonth
    case noConvertDay
    case noFindWeekNumber
}

func findWeekNumber(inputDate:Date) -> Int{
    let weekNumber = Calendar.current.component(.weekOfYear, from: inputDate)
    return weekNumber
}

func convertDateToMonthNumber(inputDate:Date)throws -> Int{
    
    let monthNumber = Calendar.current.dateComponents([.month], from: inputDate)
    
    if let number = monthNumber.month{
        return number
    }else{
        throw CalanderErrors.noConvertMonth
    }
}

func convertDateToDayNumber(inputDate:Date) throws -> Int {
    let dayNumber = Calendar.current.dateComponents([.day], from: inputDate)
    
    if let number = dayNumber.day{
        return number
    }else{
        throw CalanderErrors.noConvertDay
    }
}

func findTotalCal(protien:Int, fats: Int, carbs: Int) -> Int{
    var totalCalories = 0
    totalCalories += (protien * 4)
    totalCalories += (carbs * 4)
    totalCalories += (fats * 4)
    
    return totalCalories
}

func gatherDayCalStates(currentDay: Int, mealsArr: [CalorieTrackerEntity]) -> [(Int,Int,Int,Int,Int)]{
    var weekData: [(Int,Int,Int,Int,Int)] = []
    
    
    for day in currentDay-7...currentDay{
        var totalCal = 0
        var proteinCount = 0
        var carbCount = 0
        var fatCount = 0
        
        for item in mealsArr{
            if item.dayNumber == currentDay {
                totalCal += Int(item.totalCal)
                proteinCount += Int(item.protien)
                carbCount += Int(item.carb)
                fatCount += Int(item.fat)
            }
        }
        
        weekData.append((day,totalCal,proteinCount,carbCount ,fatCount))
    }
    
    
    
    return weekData
}

func gatherWeekCalStats(currentDay: Date, mealsArr: [CalorieTrackerEntity]) -> (Int,Int,Int,Int){
    let weekNumber = findWeekNumber(inputDate: currentDay)
    
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

