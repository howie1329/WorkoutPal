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
            HStack{
                ForEach(model.dayLogTrackerLog){item in
                    Button {
                        model.currentDate = item.date!
                        if !item.isWorkoutCompleted {
                            dayLogView.toggle()
                        }else {
                            model.currentDate = item.date!
                            model.updateDayWorkout(workoutPlan: UUID())
                        }
                    } label: {
                        VStack{
                            Text("\((item.date?.formatted(date: .numeric, time: .omitted))!)")
                            if item.isWorkoutCompleted{
                                Image(systemName: "circle.fill")
                                    .foregroundColor(.green)
                            } else {
                                Image(systemName: "circle.fill")
                                    .foregroundColor(.red)
                            }
                            if item.isWorkoutCompleted {
                                ForEach(model.masterWorkoutPlanLog){masterItem in
                                    if masterItem.id == item.masterPlanID{
                                        Text("\(masterItem.focusTitle ?? "")")
                                    }
                                }
                            } else{
                                Text("No Workout")
                            }
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    
                }
            }
        }
        .sheet(isPresented: $dayLogView) {
            HomeWorkoutView(viewState: $dayLogView)
        }
    }
}
