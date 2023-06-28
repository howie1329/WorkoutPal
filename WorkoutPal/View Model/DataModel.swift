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
    @Published var foodItemTrackerLog: [FoodItemEntity] = []
    @Published var dayLogTrackerLog: [DayLogEntity] = []
    @Published var masterWorkoutPlanLog: [MasterWorkoutPlansEntity] = []
    @Published var singleWorkoutLog: [SingleWorkoutEntity] = []
    var currentDate = Date.now
    
    @Published var weekNumber = 0
    
    init(){
        container = NSPersistentContainer(name: "WorkoutPalContainer")
        container.loadPersistentStores { (description, error) in
            if let error = error{
                print("Error Loading Container \(error)")
            }
        }
        weekNumber = currentDate.findWeekNumber()
        
        
        
        fetchFoodItem()
        fetchMasterWorkoutPlans()
        fetchSingleWorkout()
        fetchDayWorkout()
        
        let item = dayLogTrackerLog.first { DayLogEntity in
            DayLogEntity.date?.formatted(date: .numeric, time: .omitted) == currentDate.formatted(date: .numeric, time: .omitted)
        }
        
        if let entry = item {
            print("Item Found")
            print("Item \(item)")
        }else{
            createDayWorkout(date: currentDate, workoutPlanId: UUID())
        }
        
    }
    
    func fetchDayWorkout(){
        let request = NSFetchRequest<DayLogEntity>(entityName: "DayLogEntity")
        do{
            dayLogTrackerLog = try container.viewContext.fetch(request)
        } catch let error{
            print("Error fetching day workout data \(error.localizedDescription)")
        }
    }
    
    func createDayWorkout(date: Date, workoutPlanId: UUID){
        let newDay = DayLogEntity(context: container.viewContext)
        newDay.id = UUID()
        newDay.date = date
        newDay.isWorkoutCompleted = false
        newDay.masterPlanID = workoutPlanId
        newDay.totalCal = 0
        newDay.totalFat = 0
        newDay.totalCarbs = 0
        newDay.totalProtein = 0
        saveData()
        
    }
    
    func deleteQuickDay(indexSet: IndexSet){
        guard let index = indexSet.first else {return}
        let entity = dayLogTrackerLog[index]
        container.viewContext.delete(entity)
        saveData()
    }
    
    func deleteDayWorkout(id: UUID){
        let item = dayLogTrackerLog.firstIndex { DayLogEntity in
            DayLogEntity.id == id
        }
        
        if let index = item{
            let entity = dayLogTrackerLog[index]
            container.viewContext.delete(entity)
            saveData()
        }
    }
    
    func updateDayWorkout(workoutPlan: UUID){
        let item = dayLogTrackerLog.firstIndex { DayLogEntity in
            DayLogEntity.date?.formatted(date: .numeric, time: .omitted) == currentDate.formatted(date: .numeric, time: .omitted)
        }
        
        if let index = item {
            let entity = dayLogTrackerLog[index]
            entity.masterPlanID = workoutPlan
            entity.isWorkoutCompleted.toggle()
            saveData()
        }
    }
    
    func updateDayLogFood(entry:DayLogEntity,totalCal: Int, totalFat:Int, totalProtein: Int, totalCarbs: Int){
        entry.totalCal += Int16(totalCal)
        entry.totalFat += Int16(totalFat)
        entry.totalCarbs += Int16(totalCarbs)
        entry.totalProtein += Int16(totalProtein)
        
        saveData()
    }
    
    //MARK: Single Workout Code
    // get all single workouts
    func fetchSingleWorkout(){
        let request = NSFetchRequest<SingleWorkoutEntity>(entityName: "SingleWorkoutEntity")
        do{
            singleWorkoutLog = try container.viewContext.fetch(request)
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
        newWorkout.reps = Int16(reps)
        newWorkout.sets = Int16(sets)
        newWorkout.weights = Int16(weights)
        newWorkout.title = title
        saveData()
    }
    // Delete a single workout
    func deleteSingleWorkout(indexSet: IndexSet){
        guard let index = indexSet.first else {return}
        let entity = singleWorkoutLog[index]
        container.viewContext.delete(entity)
        saveData()
    }
    
    //MARK: WORKOUT PLAN CODE
    // Fetch all workout plans
    func fetchMasterWorkoutPlans(){
        let request = NSFetchRequest<MasterWorkoutPlansEntity>(entityName: "MasterWorkoutPlansEntity")
        do{
            masterWorkoutPlanLog = try container.viewContext.fetch(request)
        } catch let error{
            print("Error Loading workout plans \(error)")
        }
    }
    // Create New Workout Plan
    func createWorkoutPlan(title:String,iconString:String){
        let newPlan = MasterWorkoutPlansEntity(context: container.viewContext)
        newPlan.id = UUID()
        newPlan.focusTitle = title
        newPlan.icon = iconString
        saveData()
    }
    // Delete Workout Plan
    func deleteWorkoutPlan(indexSet:IndexSet){
        guard let index = indexSet.first else {return}
        let entity = masterWorkoutPlanLog[index]
        container.viewContext.delete(entity)
        saveData()
    }

    //MARK: Calorie Tracker CODE
    ///Fetch all data from calorie tracker entity
    ///CalorieTrackerEntity holds all meal information/Data
    func fetchFoodItem(){
        let request = NSFetchRequest<FoodItemEntity>(entityName: "FoodItemEntity")
        do{
            foodItemTrackerLog = try container.viewContext.fetch(request)
        } catch let error{
            print("Error Fetching Calories Tracker Data \(error)")
        }
    }
    
    // create and save a entry to container
    func createCalorieEntry(name:String, protien:Int, carbs:Int, fats:Int, mealType:String, date: Date){
        
        let item = dayLogTrackerLog.first { DayLogEntity in
            DayLogEntity.date?.formatted(date: .numeric, time: .omitted) == currentDate.formatted(date: .numeric, time: .omitted)
        }
        
        let newFoodItem = FoodItemEntity(context: container.viewContext)
        newFoodItem.id = UUID()
        newFoodItem.name = name
        newFoodItem.date = date
        newFoodItem.dateID = item?.id
        newFoodItem.protien = Int16(protien)
        newFoodItem.carb = Int16(carbs)
        newFoodItem.fat = Int16(fats)
        newFoodItem.type = mealType
        newFoodItem.totalCal = Int16(findTotalCal(protien: protien, fats: fats, carbs: carbs))
        
        if let item = item {
            updateDayLogFood(entry: item, totalCal: Int(newFoodItem.totalCal), totalFat: Int(newFoodItem.fat), totalProtein: Int(newFoodItem.protien), totalCarbs: Int(newFoodItem.carb))
        }
        
        saveData()
    }
    // Delete Calorie Entry
    func deleteCalorieEntry(indexSet: IndexSet){
        guard let index = indexSet.first else {return}
        let entity = foodItemTrackerLog[index]
        let day = dayLogTrackerLog.first { DayLogEntity in
            DayLogEntity.id == entity.dateID
        }
        day?.totalCal -= entity.totalCal
        day?.totalCarbs -= entity.carb
        day?.totalFat -= entity.fat
        day?.totalProtein -= entity.protien
        container.viewContext.delete(entity)
        saveData()
    }
    
    // MARK: Save Data And Fetch From Container
    func saveData(){
        do{
            try container.viewContext.save()
            fetchFoodItem()
            fetchMasterWorkoutPlans()
            fetchSingleWorkout()
            fetchDayWorkout()
        }catch let error{
            print("Error Saving/fetching from Container \(error)")
        }
    }
    
    //MARK: Service Code
    func redoCurrentDates(updatedDate: Date){
        print("REDO CURRENT DATES RAN")
        
        let item = dayLogTrackerLog.first { DayLogEntity in
            DayLogEntity.date?.formatted(date: .numeric, time: .omitted) == updatedDate.formatted(date: .numeric, time: .omitted)
        }
        
        if let entry = item {
            print("Item Found")
            print("Item \(item)")
        }else{
            createDayWorkout(date: updatedDate, workoutPlanId: UUID())
        }
        
        currentDate = updatedDate
        weekNumber = currentDate.findWeekNumber()
    }
}
