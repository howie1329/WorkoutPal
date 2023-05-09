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
    var currentDate = Date.now
    @Published var currentMonth: Int = 0
    @Published var currentDay: Int = 0
    
    init(){
        container = NSPersistentContainer(name: "WorkoutContainer")
        container.loadPersistentStores { (description, error) in
            if let error = error{
                print("Error Loading Container \(error)")
            }
        }
        currentMonth = try! convertDateToMonthNumber(inputDate: currentDate)
        currentDay = try! convertDateToDayNumber(inputDate: currentDate)
        
        fetchCalorieTracker()
        fetchWorkoutPlans()
        fetchSingleWorkout()
        
    }
    
    //MARK: Single Workout Code
    func fetchSingleWorkout(){
        let request = NSFetchRequest<SingleWorkoutEntity>(entityName: "SingleWorkoutEntity")
        do{
            singleWorkoutsLog = try container.viewContext.fetch(request)
        } catch let error{
            print("Error fetching single workouts \(error)")
        }
    }
    
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
    
    func deleteSingleWorkout(indexSet: IndexSet){
        guard let index = indexSet.first else {return}
        let entity = singleWorkoutsLog[index]
        container.viewContext.delete(entity)
        saveData()
    }
    
    //MARK: WORKOUT CODE
    
    func fetchWorkoutPlans(){
        let request = NSFetchRequest<WorkoutPlansEntity>(entityName: "WorkoutPlansEntity")
        do{
            workoutPlansLog = try container.viewContext.fetch(request)
        } catch let error{
            print("Error Loading workout plans \(error)")
        }
    }
    
    func createWorkoutPlan(_ title:String){
        let newPlan = WorkoutPlansEntity(context: container.viewContext)
        newPlan.id = UUID()
        newPlan.focusTitle = title
        saveData()
    }
    
    func deleteWorkoutPlan(indexSet:IndexSet){
        guard let index = indexSet.first else {return}
        let entity = workoutPlansLog[index]
        container.viewContext.delete(entity)
        saveData()
    }
    
    //MARK: Service Code
    /// -- TODO: Need to move to own file
    
    enum CalanderErrors: Error {
        case noConvertMonth
        case noConvertDay
    }

    func redoCurrentDates(updatedDate: Date){
        print("REDO CURRENT DATES RAN")
        currentDate = updatedDate
        currentMonth = try! convertDateToMonthNumber(inputDate: currentDate)
        currentDay = try! convertDateToDayNumber(inputDate: currentDate)
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
    
    ///create and save a entry to container
    func createCalorieEntry(name:String, protien:Int, carbs:Int, fats:Int, mealType:String){
        let trackerEntry = CalorieTrackerEntity(context: container.viewContext)
        trackerEntry.id = UUID()
        trackerEntry.name = name
        trackerEntry.protien = Int32(protien)
        trackerEntry.carb = Int32(carbs)
        trackerEntry.fat = Int32(fats)
        trackerEntry.dayNumber = Int32(try! convertDateToDayNumber(inputDate: currentDate))
        trackerEntry.monthNumber = Int32(try! convertDateToMonthNumber(inputDate: currentDate))
        trackerEntry.type = mealType
        trackerEntry.totalCal = Int32(findTotalCal(protien: protien, fats: fats, carbs: carbs))
        saveData()
    }
    
    func deleteCalorieEntry(indexSet: IndexSet){
        guard let index = indexSet.first else {return}
        let entity = calorieTrackerLog[index]
        container.viewContext.delete(entity)
        saveData()
    }
    
    /// save data and fetch from container
    func saveData(){
        do{
            try container.viewContext.save()
            fetchCalorieTracker()
            fetchWorkoutPlans()
            fetchSingleWorkout()
        }catch let error{
            print("Error Saving/fetching from Container \(error)")
        }
    }
}
