//
//  DataModel.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 5/5/23.
//

import CoreData
import Foundation


class DataModel: ObservableObject {
    
    let container: NSPersistentContainer
    
    var currentDate = Date.now
    @Published var currentMonth: Int = 0
    @Published var currentDay: Int = 0
    @Published var weekNumber = 0
    @Published var weekDayData: [(Int,Int,Int,Int,Int,Bool)] = []
    
    @Published var calorieDataModel:CalorieDataModel
    @Published var workoutDataModel:WorkoutDataModel
    
    init(){
        container = NSPersistentContainer(name: "WorkoutContainer")
        container.loadPersistentStores { (description, error) in
            if let error = error{
                print("Error Loading Container \(error)")
            }
        }
        currentMonth = try! convertDateToMonthNumber(inputDate: currentDate)
        currentDay = try! convertDateToDayNumber(inputDate: currentDate)
        weekNumber = findWeekNumber(inputDate: currentDate)
        
        calorieDataModel = CalorieDataModel(container: container)
        workoutDataModel = WorkoutDataModel(container: container)
        
        calorieDataModel.fetchCalorieTracker()
        workoutDataModel.fetchSingleWorkout()
        workoutDataModel.fetchWorkoutPlans()
        workoutDataModel.fetchDayWorkout()
        
        
        weekDayData = gatherDayCalStates(currentDay: currentDay, mealsArr: calorieDataModel.calorieTrackerLog, dayWorkoutArr: workoutDataModel.dayWorkoutLog)
        
    }
    
    func updateWeekDayData(){
        weekDayData = gatherDayCalStates(currentDay: currentDay, mealsArr:calorieDataModel.calorieTrackerLog, dayWorkoutArr: workoutDataModel.dayWorkoutLog)
    }
    
    //MARK: Service Code
    /// -- TODO: Need to move to own file
    func redoCurrentDates(updatedDate: Date){
        print("REDO CURRENT DATES RAN")
        currentDate = updatedDate
        currentMonth = try! convertDateToMonthNumber(inputDate: currentDate)
        currentDay = try! convertDateToDayNumber(inputDate: currentDate)
        weekNumber = findWeekNumber(inputDate: currentDate)
        updateWeekDayData()
    }
    
    /// save data and fetch from container
    func saveData(){
        do{
            try container.viewContext.save()
            calorieDataModel.fetchCalorieTracker()
            workoutDataModel.fetchSingleWorkout()
            workoutDataModel.fetchWorkoutPlans()
            workoutDataModel.fetchDayWorkout()
        }catch let error{
            print("Error Saving/fetching from Container \(error)")
        }
    }
}
