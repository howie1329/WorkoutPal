//
//  CalorieDataModel.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 5/19/23.
//

import Foundation
import CoreData

class CalorieDataModel: ObservableObject {
    
    let container: NSPersistentContainer
    
    var currentDate = Date.now
    
    @Published var calorieTrackerLog: [CalorieTrackerEntity] = []
    
    init(container: NSPersistentContainer){
        self.container = container
    }
    
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
        trackerEntry.weekNumber = Int32(findWeekNumber(inputDate: currentDate))
        do{
            try container.viewContext.save()
        } catch let error{
            print("Error saving \(error)")
        }
    }
    
    func deleteCalorieEntry(indexSet: IndexSet){
        guard let index = indexSet.first else {return}
        let entity = calorieTrackerLog[index]
        container.viewContext.delete(entity)
        do{
            try container.viewContext.save()
        } catch let error{
            print("Error saving \(error)")
        }
    }
    
}
