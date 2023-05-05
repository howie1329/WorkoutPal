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
    
    init(){
        container = NSPersistentContainer(name: "WorkoutContainer")
        container.loadPersistentStores { (description, error) in
            if let error = error{
                print("Error Loading Container \(error)")
            }
        }
        fetchCalorieTracker()
        calorieTrackerEntry(name: "Pancakes", protien: 15, carbs: 89, fats: 50, mealType: "breakfast")
    }
    
    func fetchCalorieTracker(){
        let request = NSFetchRequest<CalorieTrackerEntity>(entityName: "CalorieTrackerEntity")
        do{
            calorieTrackerLog = try container.viewContext.fetch(request)
        } catch let error{
            print("Error Fetching Calories Tracker Data \(error)")
        }
    }
    
    func calorieTrackerEntry(name:String, protien:Int, carbs:Int, fats:Int, mealType:String){
        let trackerEntry = CalorieTrackerEntity(context: container.viewContext)
        trackerEntry.id = UUID()
        trackerEntry.name = name
        trackerEntry.protien = Int32(protien)
        trackerEntry.carb = Int32(carbs)
        trackerEntry.fat = Int32(fats)
        trackerEntry.type = mealType
        saveData()
    }
    
    func saveData(){
        do{
            try container.viewContext.save()
        }catch let error{
            print("Error Saving Container \(error)")
        }
    }
}
