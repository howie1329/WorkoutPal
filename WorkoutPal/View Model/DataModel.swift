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
        
    }
    
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
        }catch let error{
            print("Error Saving/fetching from Container \(error)")
        }
    }
}
