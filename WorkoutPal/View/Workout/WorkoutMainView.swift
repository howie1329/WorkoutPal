//
//  WorkoutView.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 5/9/23.
//

import SwiftUI

struct WorkoutMainView: View {
    @EnvironmentObject var model: DataModel
    private let viewChoice = ["Plans", "Single"]
    @State var newPlanView = false
    @State var viewSelection = "Plans"
    var body: some View {
        NavigationStack {
            VStack {
                HStack{
                    Text("Workout Plans")
                        .font(.title)
                        .bold()
                    Spacer()
                    Button {
                        newPlanView = true
                    } label: {
                        Image(systemName: "plus.circle")
                            .resizable()
                            .frame(width:20, height: 20)
                    }.tint(.black)
                }
                .frame(maxWidth: .infinity, alignment:.leading)
                .padding([.top,.horizontal])
                Picker("view picker", selection: $viewSelection) {
                    ForEach(viewChoice, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.segmented)
                if viewSelection == "Plans"{
                    List {
                        ForEach(model.masterWorkoutPlanLog) {item in
                            NavigationLink(destination: WorkoutPlanRowView(planItem: item)) {
                                HStack {
                                    Image(systemName: item.icon ?? "figure.run")
                                    Text(item.focusTitle ?? "")
                                }
                            }                        }
                    }
                    .listStyle(.inset)
                } else if viewSelection == "Single"{
                    List {
                        ForEach(model.singleWorkoutLog) {item in
                            WorkoutSectionView(filerSection: "Full Body", singleWorkoutItem: item)
                            WorkoutSectionView(filerSection: "Upper Body", singleWorkoutItem: item)
                            WorkoutSectionView(filerSection: "Lower Body", singleWorkoutItem: item)
                        }
                    }
                    .listStyle(.inset)
                }
            }
            .sheet(isPresented: $newPlanView, content: {
                NewWorkoutPlanView(viewState: $newPlanView)
                    .presentationDetents([.fraction(3/8)])
            })
        }
    }
}

struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutMainView()
            .environmentObject(DataModel())
    }
}
