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
    @Published var calorieTrackerLog: [CalorieTrackerEntity] = []
    @Published var workoutPlansLog: [WorkoutPlansEntity] = []
    @Published var singleWorkoutsLog: [SingleWorkoutEntity] = []
    @Published var dayWorkoutLog: [DayWorkoutEntity] = []
    var currentDate = Date.now
    @Published var currentMonth: Int = 0
    @Published var currentDay: Int = 0
    @Published var weekNumber = 0
    @Published var weekDayData: [(Int,Int,Int,Int,Int,Bool)] = []
    
    init(){
        container = NSPersistentContainer(name: "WorkoutContainer")
        container.loadPersistentStores { (description, error) in
            if let error = error{
                print("Error Loading Container \(error)")
            }
        }
        currentMonth = currentDate.findMonthNumber()
        currentDay = currentDate.findDayNumber()
        weekNumber = currentDate.findWeekNumber()
        
        fetchCalorieTracker()
        fetchWorkoutPlans()
        fetchSingleWorkout()
        fetchDayWorkout()
        
        weekDayData = gatherDayCalStates(currentDay: currentDay, mealsArr: calorieTrackerLog, dayWorkoutArr: dayWorkoutLog)
        
    }
    
    func updateWeekDayData(){
        weekDayData = gatherDayCalStates(currentDay: currentDay, mealsArr: calorieTrackerLog, dayWorkoutArr: dayWorkoutLog)
    }
    
    func fetchDayWorkout(){
        let request = NSFetchRequest<DayWorkoutEntity>(entityName: "DayWorkoutEntity")
        do{
            dayWorkoutLog = try container.viewContext.fetch(request)
        } catch let error{
            print("Error fetching day workout data \(error.localizedDescription)")
        }
    }
    
    func createDayWorkout(day:Int, workoutPlanId: UUID){
        let newDay = DayWorkoutEntity(context: container.viewContext)
        newDay.id = UUID()
        newDay.isCompleted = true
        newDay.dayNumber = Int16(day)
        newDay.monthNumber = Int16(currentMonth)
        newDay.workoutPlanId = workoutPlanId
        saveData()
        
    }
    
    func deleteDayWorkout(dayNumber: Int){
        print("\(dayWorkoutLog)")
        print("DayNumber: \(dayNumber)")
        let item = dayWorkoutLog.firstIndex { DayWorkoutEntity in
            DayWorkoutEntity.dayNumber == Int16(dayNumber) && DayWorkoutEntity.monthNumber == Int16(currentMonth)
        }
        
        if let index = item{
            let entity = dayWorkoutLog[index]
            container.viewContext.delete(entity)
            print("Index: \(index)")
            saveData()
        }
    }
    
    func updateDayWorkout(dayNumber: Int){
        let item = dayWorkoutLog.firstIndex { DayWorkoutEntity in
            DayWorkoutEntity.dayNumber == Int16(dayNumber) && DayWorkoutEntity.monthNumber == Int16(currentMonth)
        }
        
        if let index = item {
            print("item found")
            dayWorkoutLog[index].isCompleted = true
            saveData()
        }
        
    }
    
    //MARK: Single Workout Code
    // get all single workouts
    func fetchSingleWorkout(){
        let request = NSFetchRequest<SingleWorkoutEntity>(entityName: "SingleWorkoutEntity")
        do{
            singleWorkoutsLog = try container.viewContext.fetch(request)
        } catch let error{
            print("Error fetching single workouts \(error)")
        }
    }
    // create a single workout
    func createSingleWorkout(plansID: UUID, focusGroup:String, reps:Int,sets:Int, weights:Int, title:String ){
        let newWorkout = SingleWorkoutEntity(context: container.viewContext)
        newWorkout.id = UUID()
        newWorkout.ownerID = plansID
        newWorkout.focusGroup = focusGroup
        newWorkout.reps = Int32(reps)
        newWorkout.sets = Int32(sets)
        newWorkout.weight = Int32(weights)
        newWorkout.workoutTitle = title
        saveData()
    }
    // Delete a single workout
    func deleteSingleWorkout(indexSet: IndexSet){
        guard let index = indexSet.first else {return}
        let entity = singleWorkoutsLog[index]
        container.viewContext.delete(entity)
        saveData()
    }
    
    //MARK: WORKOUT PLAN CODE
    // Fetch all workout plans
    func fetchWorkoutPlans(){
        let request = NSFetchRequest<WorkoutPlansEntity>(entityName: "WorkoutPlansEntity")
        do{
            workoutPlansLog = try container.viewContext.fetch(request)
        } catch let error{
            print("Error Loading workout plans \(error)")
        }
    }
    // Create New Workout Plan
    func createWorkoutPlan(title:String,iconString:String){
        let newPlan = WorkoutPlansEntity(context: container.viewContext)
        newPlan.id = UUID()
        newPlan.focusTitle = title
        newPlan.icon = iconString
        saveData()
    }
    // Delete Workout Plan
    func deleteWorkoutPlan(indexSet:IndexSet){
        guard let index = indexSet.first else {return}
        let entity = workoutPlansLog[index]
        container.viewContext.delete(entity)
        saveData()
    }

    //MARK: Calorie Tracker CODE
    ///Fetch all data from calorie tracker entity
    ///CalorieTrackerEntity holds all meal information/Data
    func fetchCalorieTracker(){
        let request = NSFetchRequest<CalorieTrackerEntity>(entityName: "CalorieTrackerEntity")
        do{
            calorieTrackerLog = try container.viewContext.fetch(request)
        } catch let error{
            print("Error Fetching Calories Tracker Data \(error)")
        }
    }
    
    // create and save a entry to container
    func createCalorieEntry(name:String, protien:Int, carbs:Int, fats:Int, mealType:String){
        let trackerEntry = CalorieTrackerEntity(context: container.viewContext)
        trackerEntry.id = UUID()
        trackerEntry.name = name
        trackerEntry.protien = Int32(protien)
        trackerEntry.carb = Int32(carbs)
        trackerEntry.fat = Int32(fats)
        trackerEntry.dayNumber = Int32(currentDate.findDayNumber())
        trackerEntry.monthNumber = Int32(currentDate.findMonthNumber())
        trackerEntry.type = mealType
        trackerEntry.totalCal = Int32(findTotalCal(protien: protien, fats: fats, carbs: carbs))
        trackerEntry.weekNumber = Int32(currentDate.findWeekNumber())
        saveData()
    }
    // Delete Calorie Entry
    func deleteCalorieEntry(indexSet: IndexSet){
        guard let index = indexSet.first else {return}
        let entity = calorieTrackerLog[index]
        container.viewContext.delete(entity)
        saveData()
    }
    
    // MARK: Save Data And Fetch From Container
    func saveData(){
        do{
            try container.viewContext.save()
            fetchCalorieTracker()
            fetchWorkoutPlans()
            fetchSingleWorkout()
            fetchDayWorkout()
            updateWeekDayData()
        }catch let error{
            print("Error Saving/fetching from Container \(error)")
        }
    }
    
    //MARK: Service Code
    func redoCurrentDates(updatedDate: Date){
        print("REDO CURRENT DATES RAN")
        currentDate = updatedDate
        currentMonth = currentDate.findMonthNumber()
        currentDay = currentDate.findDayNumber()
        weekNumber = currentDate.findWeekNumber()
        updateWeekDayData()
    }
}
