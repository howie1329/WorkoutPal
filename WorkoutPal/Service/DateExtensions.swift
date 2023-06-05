//
//  DateExtensions.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 6/5/23.
//

import Foundation

extension Date{
    
    /// Finds the number that represents the week on the calender
    /// - Returns: the week number for a given date
    func findWeekNumber() -> Int{
        return Calendar.current.component(.weekOfYear, from: self)
        
    }
    
    /// returns the number of the month a day falls in
    /// - Returns: the number of a month a day falls in
    func findMonthNumber() -> Int{
        return Calendar.current.component(.month, from: self)
        
    }
    
    /// returns the number of the day given from a date
    /// - Returns: a the number of the day given from a date
    func findDayNumber() -> Int {
        
        return Calendar.current.component(.day, from: self)
    }
    
    
}
