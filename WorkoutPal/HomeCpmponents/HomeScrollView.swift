//
//  HomeScrollView.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 5/17/23.
//

import SwiftUI

struct HomeScrollView: View {
    @EnvironmentObject var model: DataModel
    
    @State var showAlert = false
    @State var showCreateView = false
    var weekData: weekModel
    
    var body: some View {
        ScrollView(.horizontal){
            HStack{
                ForEach(weekData.dayInfo){item in
                    Button {
                        if item.isCompleted{
                            model.currentDate = item.date
                            //selectedDate = item
                            showAlert.toggle()
                        }else {
                            //selectedDate = item
                            model.currentDate = item.date
                            showCreateView.toggle()
                        }
                        
                    } label: {
                        VStack(spacing:7){
                            VStack{
                                Text("\(item.date)")
                                    .font(.title)
                                    .bold()
                                Text("\(item.date)")
                                    .font(.headline)
                            }
                            if item.isCompleted{
                                Image(systemName: "circle.fill")
                                    .foregroundColor(.green)
                            }else{
                                Image(systemName: "circle.fill")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .alert(isPresented:$showAlert){
                        Alert(title: Text("Are You Sure"),message: Text("This will delete this days workout data"), primaryButton: .cancel(), secondaryButton: .destructive(Text("Delete")){
                            model.deleteDayWorkout(id: item.id)
                        })
                    }
                    .sheet(isPresented: $showCreateView, content: {
                        HomeWorkoutView(workoutDate: model.currentDate, viewState: $showCreateView)
                    })
                }
            }
        }
        //.scrollIndicators(.hidden)
        .padding()
    }
}
