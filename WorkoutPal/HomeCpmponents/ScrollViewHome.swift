//
//  ScrollView.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 6/25/23.
//

import SwiftUI

struct ScrollViewHome: View {
    @EnvironmentObject var model: DataModel
    @State var weekStats: weekModel
    @State var dayLogView = false
    var body: some View {
        ScrollView(.horizontal){
            ForEach(model.dayLogTrackerLog){item in
                Button {
                    model.currentDate = item.date!
                    if !item.isWorkoutCompleted {
                        dayLogView.toggle()
                    }
                } label: {
                    Text("\((item.date?.formatted(date: .abbreviated, time: .omitted))!)")
                }

            }
        }
        .sheet(isPresented: $dayLogView) {
            HomeWorkoutView(viewState: $dayLogView)
        }
    }
}
