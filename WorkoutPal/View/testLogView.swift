//
//  testLogView.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 6/25/23.
//

import SwiftUI

struct TestLogView: View {
    @EnvironmentObject var dataModel: DataModel
    var body: some View {
        VStack {
            List {
                ForEach(dataModel.dayLogTrackerLog) {item in
                    VStack {
                        Text("Date: \(item.date ?? Date.now)")
                        Text("Cal \(item.totalCal)")
                        if let id = item.id {
                            Text("\(id)")
                        }
                    }
                }.onDelete(perform: dataModel.deleteQuickDay)
            }
        }
    }
}
