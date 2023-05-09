//
//  ContentView.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 5/5/23.
//

import SwiftUI

struct CalorieTrackerView: View {
    @EnvironmentObject var model:DataModel
    @State var newMealView = false
    @State var dateChoice = Date.now
    @State var totalCalories = 0
    @State var protienCount = 0
    @State var fatCount = 0
    @State var carbCount = 0
    var body: some View {
        NavigationView{
            VStack {
                HStack{
                    Text("Total Calories: \(totalCalories)")
                    Text("Proteins: \(protienCount)")
                    Text("Fats: \(fatCount)")
                    Text("Carbs: \(carbCount)")
                }
                HStack{
                    DatePicker("", selection: $dateChoice,displayedComponents: .date)
                    Button {
                        dateChoice = Date.now
                    } label: {
                        Text("Today")
                    }
                    .buttonStyle(.borderedProminent)
                }
                .labelsHidden()
                .frame(maxWidth: .infinity,alignment: .center)
                .onChange(of: dateChoice) { _ in
                    model.redoCurrentDates(updatedDate: dateChoice)
                    totalCalories = 0
                    protienCount = 0
                    fatCount = 0
                    carbCount = 0
                }
                .padding(.horizontal)
                List {
                    ForEach(model.calorieTrackerLog){item in
                        if model.currentDay == item.dayNumber && model.currentMonth == item.monthNumber{
                            
                            CalorieSectionView(filterSelection: "Breakfast", foodItem: item, totalCalories: $totalCalories, protienCount: $protienCount, fatCount: $fatCount, carbCount: $carbCount)
                            CalorieSectionView(filterSelection: "Lunch", foodItem: item, totalCalories: $totalCalories, protienCount: $protienCount, fatCount: $fatCount, carbCount: $carbCount)
                            CalorieSectionView(filterSelection: "Dinner", foodItem: item, totalCalories: $totalCalories, protienCount: $protienCount, fatCount: $fatCount, carbCount: $carbCount)
                            CalorieSectionView(filterSelection: "Snack", foodItem: item, totalCalories: $totalCalories, protienCount: $protienCount, fatCount: $fatCount, carbCount: $carbCount)
                            
                        }
                        
                    }
                    .onDelete(perform: model.deleteCalorieEntry)
                }
                .listStyle(.inset)
            }
            .navigationTitle("Calorie Tracker")
            .sheet(isPresented: $newMealView, content: {
                AddMealView(viewState: $newMealView)
                    .presentationDetents([.medium])
            })
            .toolbar {
                Button {
                    newMealView = true
                } label: {
                    Image(systemName: "plus.circle")
                }
                
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CalorieTrackerView()
            .environmentObject(DataModel())
    }
}
