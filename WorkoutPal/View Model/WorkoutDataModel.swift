//
//  WorkoutDataModel.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 5/19/23.
//

import CoreData
import Foundation

class WorkoutDataModel {
    
    let container: NSPersistentContainer
    
    @Published var workoutPlansLog: [WorkoutPlansEntity] = []
    @Published var singleWorkoutsLog: [SingleWorkoutEntity] = []
    @Published var dayWorkoutLog: [DayWorkoutEntity] = []
    
    init(container: NSPersistentContainer) {
        self.container = container
    }
    
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
        do{
            try container.viewContext.save()
        } catch let error{
            print("Error saving \(error)")
        }
    }
    
    func deleteSingleWorkout(indexSet: IndexSet){
        guard let index = indexSet.first else {return}
        let entity = singleWorkoutsLog[index]
        container.viewContext.delete(entity)
        do{
            try container.viewContext.save()
        } catch let error{
            print("Error saving \(error)")
        }
    }
    
    //MARK: WORKOUT PLAN CODE
    
    func fetchWorkoutPlans(){
        let request = NSFetchRequest<WorkoutPlansEntity>(entityName: "WorkoutPlansEntity")
        do{
            workoutPlansLog = try container.viewContext.fetch(request)
        } catch let error{
            print("Error Loading workout plans \(error)")
        }
    }
    
    func createWorkoutPlan(title:String,iconString:String){
        let newPlan = WorkoutPlansEntity(context: container.viewContext)
        newPlan.id = UUID()
        newPlan.focusTitle = title
        newPlan.icon = iconString
        do{
            try container.viewContext.save()
        } catch let error{
            print("Error saving \(error)")
        }
    }
    
    func deleteWorkoutPlan(indexSet:IndexSet){
        guard let index = indexSet.first else {return}
        let entity = workoutPlansLog[index]
        container.viewContext.delete(entity)
        do{
            try container.viewContext.save()
        } catch let error{
            print("Error saving \(error)")
        }
    }
    
    func fetchDayWorkout(){
        let request = NSFetchRequest<DayWorkoutEntity>(entityName: "DayWorkoutEntity")
        do{
            dayWorkoutLog = try container.viewContext.fetch(request)
        } catch let error{
            print("Error fetching day workout data \(error.localizedDescription)")
        }
    }
    
    func createDayWorkout(day:Int){
        let newDay = DayWorkoutEntity(context: container.viewContext)
        newDay.id = UUID()
        newDay.isCompleted = true
        newDay.dayNumber = Int16(day)
        newDay.monthNumber = 0
        do{
            try container.viewContext.save()
        } catch let error{
            print("Error saving \(error)")
        }
        
    }
    
    func updateDayWorkout(dayNumber: Int){
        let item = dayWorkoutLog.firstIndex { DayWorkoutEntity in
            DayWorkoutEntity.dayNumber == Int16(dayNumber)
        }
        
        if let index = item {
            print("item found")
            dayWorkoutLog[index].isCompleted.toggle()
            do{
                try container.viewContext.save()
            } catch let error{
                print("Error saving \(error)")
            }
            //updateWeekDayData()
        }
        
    }
    
}
