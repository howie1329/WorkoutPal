//
//  AddMealView.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 5/8/23.
//

import SwiftUI

struct AddMealView: View {
    @EnvironmentObject var model: DataModel
    private let mealTypes = ["Breakfast", "Lunch", "Dinner", "Snack"]
    @State var mealTitle = ""
    @State var mealType = "Breakfast"
    @State var proteinCount = 0
    @State var fatCount = 0
    @State var carbCount = 0
    @Binding var viewState: Bool
    var body: some View {
        VStack {
            HStack {
                Text("New Meal")
                    .font(.title)
                    .bold()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            TextField("Meal Title", text: $mealTitle)
                .padding(5)
            ScrollView(.horizontal){
                HStack {
                    Section(header: Text("Proteins:")){
                        TextField("Proteins: \(proteinCount)", value: $proteinCount, format: .number)
                    }
                    Section(header: Text("Fats:")){
                        TextField("Fats: \(fatCount)", value: $fatCount, format: .number)
                    }
                    Section(header: Text("Carbs:")){
                        TextField("Carbs: \(carbCount)", value: $carbCount, format: .number)
                    }
                }
            }
            .scrollIndicators(.hidden)
            Picker("Meal Type", selection: $mealType) {
                ForEach(mealTypes, id: \.self) {item in
                    Text(item)
                }
            }
            .pickerStyle(.segmented)
            Divider()
                .padding(.vertical, 5)
            Button {
                model.createCalorieEntry(name: mealTitle, protien: proteinCount, carbs: carbCount, fats: fatCount, mealType: mealType, date: model.currentDate)
                viewState = false
            } label: {
                Text("Add Meal")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding(.vertical)
            
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding()
    }
}
