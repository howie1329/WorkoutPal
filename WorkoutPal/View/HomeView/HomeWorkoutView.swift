//
//  HomeWorkoutView.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 5/19/23.
//

import SwiftUI

struct HomeWorkoutView: View {
    @EnvironmentObject var model:DataModel
    var workoutDate: Int
    @Binding var viewState: Bool
    var body: some View {
        VStack{
            Text("Your Plans")
                .font(.title.bold())
                .padding(.top)
            List {
                ForEach(model.workoutPlansLog){item in
                    HStack{
                        Image(systemName: item.icon ?? "")
                        Text(item.focusTitle ?? "")
                            .bold()
                        Spacer()
                        Button {
                            model.createDayWorkout(day: workoutDate, workoutPlanId: item.id!)
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
