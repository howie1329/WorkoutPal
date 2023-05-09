//
//  NewWorkPlanView.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 5/9/23.
//

import SwiftUI

struct NewWorkoutPlanView: View {
    @EnvironmentObject var model:DataModel
    @State var planTitle = ""
    @Binding var viewState:Bool
    var body: some View {
        VStack{
            VStack{
                Text("New Workout Plan")
                    .font(.title.bold())
            }.frame(maxWidth:.infinity,alignment:.leading)
            VStack{
                TextField("Plan Title", text: $planTitle)
                Button {
                    model.createWorkoutPlan(planTitle)
                    viewState = false
                } label: {
                    Text("Submit")
                        .frame(maxWidth:.infinity)
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
    }
}
