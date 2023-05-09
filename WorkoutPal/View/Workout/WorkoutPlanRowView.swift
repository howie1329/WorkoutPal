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
                ForEach(model.singleWorkoutsLog){item in
                    if item.ownerID == planItem.id{
                        SingleWorkoutPlanRowView(item: item)
                    }
                }
                .onDelete(perform: model.deleteSingleWorkout)
            }
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
