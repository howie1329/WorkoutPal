//
//  NewWorkPlanView.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 5/9/23.
//

import SwiftUI

struct NewWorkoutPlanView: View {
    @EnvironmentObject var model:DataModel
    private let iconArr = ["dumbbell.fill", "figure.run", "sportscourt.fill"]
    @State var planTitle = ""
    @State var iconString = "figure.run"
    @Binding var viewState:Bool
    var body: some View {
        VStack{
            VStack{
                Text("New Workout Plan")
                    .font(.title.bold())
            }.frame(maxWidth:.infinity,alignment:.leading)
            VStack(spacing:25){
                TextField("Plan Title", text: $planTitle)
                    .padding(5)
                    .background(RoundedRectangle(cornerRadius:10).fill(Color.gray))
                    
                Picker("Icon", selection: $iconString) {
                    ForEach(iconArr, id:\.self){item in
                        Image(systemName: item)
                    }
                }
                .pickerStyle(.segmented)
                Divider()
                    .padding(.vertical,5)
                Button {
                    model.workoutDataModel.createWorkoutPlan(title: planTitle, iconString: iconString)
                    model.saveData()
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
