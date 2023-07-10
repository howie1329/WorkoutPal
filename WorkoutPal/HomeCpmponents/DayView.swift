//
//  DayView.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 7/9/23.
//

import SwiftUI
import Charts

struct DayView: View {
    @EnvironmentObject var model: DataModel
    @State var selectedDate = Date.now
    @State var dayStats = DayModel(totalCal: 0, date: Date.now, protein: 0, carbs: 0, fats: 0, isCompleted: false)
    var body: some View {
        VStack{
            DatePicker("", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(.compact)
            Text("\(dayStats.totalCal)")
            Chart {
                BarMark(x: .value("Day", "Total Cal"), y: .value("", dayStats.totalCal))
                BarMark(x: .value("Day", "Protein"), y: .value("", dayStats.protein))
                BarMark(x: .value("Day", "Carbs"), y: .value("", dayStats.carbs))
                BarMark(x: .value("Day", "Fats"), y: .value("", dayStats.fats))
            }
            .frame(maxWidth: .infinity, maxHeight: 200)
        }
        .onChange(of: selectedDate) { _ in
            model.redoCurrentDates(updatedDate: selectedDate)
            dayStats = model.testFunc(date: selectedDate)
        }
        .onAppear {
            dayStats = model.testFunc(date: model.currentDate)
        }
        
    }
}

struct DayView_Previews: PreviewProvider {
    static var previews: some View {
        DayView()
    }
}
