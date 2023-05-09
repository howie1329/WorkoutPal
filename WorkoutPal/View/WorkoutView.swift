//
//  WorkoutView.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 5/9/23.
//

import SwiftUI

struct WorkoutView: View {
    @EnvironmentObject var model:DataModel
    @State var newPlanView = false
    var body: some View {
        NavigationView{
            VStack{
                List {
                    ForEach(model.workoutPlansLog){item in
                        NavigationLink(destination: WorkoutPlanMainView(planItem:item)) {
                            Text(item.focusTitle ?? "")
                        }
                        
                    }
                }
            }
            .sheet(isPresented: $newPlanView, content: {
                NewWorkPlanView(viewState: $newPlanView)
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
        WorkoutView()
            .environmentObject(DataModel())
    }
}
