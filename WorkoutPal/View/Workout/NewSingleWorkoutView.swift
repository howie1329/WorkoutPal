//
//  WorkoutPlanMainView.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 5/9/23.
//

import SwiftUI

struct NewSingleWorkoutView: View {
    @EnvironmentObject var model: DataModel
    private let focusGroup = ["Full Body", "Upper Body", "Lower Body"]
    @State var planItem: MasterWorkoutPlansEntity
    @State var title = ""
    @State var reps = 0
    @State var sets = 0
    @State var weights = 0
    @State var focusGroupTitle = "Full Body"
    @Binding var viewState: Bool
    var body: some View {
        VStack {
            HStack {
                Text("New Workout")
                    .font(.title.bold())
            }
            TextField("Workout Title", text: $title)
                .padding(5)
                .textFieldStyle(.roundedBorder)
            Picker("Focus Group", selection: $focusGroupTitle) {
                ForEach(focusGroup, id: \.self) {item in
                    Text(item)
                }
            }
            .pickerStyle(.segmented)
            Divider()
                .padding(.vertical, 5)
            VStack {
                Section(header: Text("Reps")) {
                    TextField("Rep Count", value: $reps, format: .number)
                        .padding(5)
                        .textFieldStyle(.roundedBorder)
                }
                Section(header: Text("Sets")) {
                    TextField("Set Count", value: $sets, format: .number)
                        .padding(5)
                        .textFieldStyle(.roundedBorder)
                }
                Section(header: Text("Weight")) {
                    TextField("Weight", value: $weights, format: .number)
                        .padding(5)
                        .textFieldStyle(.roundedBorder)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Divider()
                .padding(.vertical, 5)
            Button {
                model.createSingleWorkout(plansID: planItem.id ?? UUID(), focusGroup: focusGroupTitle, reps: reps, sets: sets, weights: weights, title: title)
                viewState = false
            } label: {
                Text("Submit")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)

        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding()
    }
}
