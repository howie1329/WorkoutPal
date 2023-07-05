//
//  HomeWorkoutView.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 5/19/23.
//

import SwiftUI

struct HomeWorkoutView: View {
    @EnvironmentObject var model: DataModel
    @Binding var viewState: Bool
    var body: some View {
        VStack {
            Text("Your Plans")
                .font(.title.bold())
                .padding(.top)
            List {
                ForEach(model.masterWorkoutPlanLog) {item in
                    HStack {
                        Image(systemName: item.icon ?? "")
                        Text(item.focusTitle ?? "")
                            .bold()
                        Spacer()
                        Button {
                            model.updateDayWorkout(workoutPlan: item.id!)
                            viewState = false
                        } label: {
                            Image(systemName: "plus.circle")
                        }

                    }

                }
            }
        }
    }
}
