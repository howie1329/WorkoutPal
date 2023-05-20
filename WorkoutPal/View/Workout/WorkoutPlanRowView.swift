//
//  WorkoutPlanMainView.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 5/9/23.
//

import SwiftUI

struct WorkoutPlanRowView: View {
    @EnvironmentObject var model:DataModel
    @State var planItem:WorkoutPlansEntity
    @State var newWorkoutView = false
    var body: some View {
        VStack{
            List{
                ForEach(model.workoutDataModel.singleWorkoutsLog){item in
                    if item.ownerID == planItem.id{
                        WorkoutSectionView(filerSection: "Full Body", singleWorkoutItem: item)
                        WorkoutSectionView(filerSection: "Upper Body", singleWorkoutItem: item)
                        WorkoutSectionView(filerSection: "Lower Body", singleWorkoutItem: item)
                    }
                }
                .onDelete(perform: model.workoutDataModel.deleteSingleWorkout)
            }
            .listStyle(.inset)
        }
        .sheet(isPresented: $newWorkoutView, content: {
            NewSingleWorkoutView(planItem: planItem, viewState: $newWorkoutView)
        })
        .toolbar(content: {
            Button {
                newWorkoutView = true
            } label: {
                Image(systemName: "plus.circle")
            }
            
        })
        .navigationTitle(planItem.focusTitle ?? "")
    }
}
