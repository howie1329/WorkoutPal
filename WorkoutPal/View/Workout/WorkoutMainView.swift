//
//  WorkoutView.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 5/9/23.
//

import SwiftUI

struct WorkoutMainView: View {
    @EnvironmentObject var model:DataModel
    private let viewChoice = ["Plans","Single"]
    @State var newPlanView = false
    @State var viewSelection = "Plans"
    var body: some View {
        NavigationStack{
            VStack{
                Picker("view picker", selection: $viewSelection) {
                    ForEach(viewChoice,id:\.self){
                        Text($0)
                    }
                }
                .pickerStyle(.segmented)
                if viewSelection == "Plans"{
                    List {
                        ForEach(model.workoutDataModel.workoutPlansLog){item in
                            NavigationLink(destination: WorkoutPlanRowView(planItem:item)) {
                                HStack{
                                    Image(systemName: item.icon ?? "figure.run")
                                    Text(item.focusTitle ?? "")
                                }
                            }
                            
                        }
                    }
                    .listStyle(.inset)
                } else if viewSelection == "Single"{
                    List{
                        ForEach(model.workoutDataModel.singleWorkoutsLog){item in
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
            .toolbar(content: {
                Button {
                    newPlanView = true
                } label: {
                    Image(systemName: "plus.circle")
                }

            })
            .navigationTitle("Workout Plans")
            
        }
        
    }
}

struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutMainView()
            .environmentObject(DataModel())
    }
}
