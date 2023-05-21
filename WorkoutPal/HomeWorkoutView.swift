//
//  HomeWorkoutView.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 5/19/23.
//

import SwiftUI

struct HomeWorkoutView: View {
    @EnvironmentObject var model:DataModel
    @Binding var viewState: Bool
    var body: some View {
        VStack{
            List {
                ForEach(model.workoutPlansLog){item in
                    HStack{
                        Image(systemName: item.icon ?? "")
                        Text(item.focusTitle ?? "")
                            .bold()
                        Spacer()
                        Button {
                            model.createDayWorkout(day: model.currentDay, workoutPlanId: item.id!)
                            viewState = false
                        } label: {
                            Image(systemName: "plus.circle")
                        }

                    }

                }
            }
        }
        .navigationTitle("Your Plans")
    }
}
