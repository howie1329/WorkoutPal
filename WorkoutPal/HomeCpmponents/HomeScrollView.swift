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
    @State var selectedDate = 0
    
    var body: some View {
        ScrollView(.horizontal){
            HStack{
                ForEach(model.weekDayData, id:\.0){item in
                    
                    Button {
                        if item.5 {
                            print("debug: \(item.0)")
                            selectedDate = item.0
                            showAlert.toggle()
                        }else {
                            print("debug: \(item.0)")
                            selectedDate = item.0
                            showCreateView.toggle()
                        }
                        
                        
                        /*if item.5 {
                            model.deleteDayWorkout(dayNumber: item.0)
                        }else{
                            model.updateDayWorkout(dayNumber: item.0)
                        } */
                    } label: {
                        VStack(spacing:7){
                            VStack{
                                Text("\(item.0)")
                                    .font(.title)
                                    .bold()
                                Text("\(item.1)")
                                    .font(.headline)
                            }
                            if item.5{
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
                            model.deleteDayWorkout(dayNumber: selectedDate)
                        })
                    }
                    .sheet(isPresented: $showCreateView, content: {
                        HomeWorkoutView(workoutDate: selectedDate, viewState: $showCreateView)
                    })
                }
            }
        }
        .scrollIndicators(.hidden)
        .padding()
    }
}


struct HomeScrollView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScrollView()
            .environmentObject(DataModel())
    }
}
