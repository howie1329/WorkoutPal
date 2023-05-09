//
//  AddMealView.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 5/8/23.
//

import SwiftUI

struct AddMealView: View {
    @EnvironmentObject var model:DataModel
    private let mealTypes = ["Breakfast","Lunch","Dinner","Snack"]
    @State var mealTitle = ""
    @State var mealType = "Breakfast"
    @State var proteinCount = 0
    @State var fatCount = 0
    @State var carbCount = 0
    @Binding var viewState:Bool
    var body: some View {
        VStack{
            HStack{
                Text("New Meal")
                    .font(.title)
                    .bold()
            }
            .frame(maxWidth:.infinity,alignment: .leading)
            TextField("Meal Title", text: $mealTitle)
            Stepper("Proteins: \(proteinCount)", value: $proteinCount)
            Stepper("Fats: \(fatCount)", value: $fatCount)
            Stepper("Carbs: \(carbCount)", value: $carbCount)
            
            Picker("Meal Type", selection: $mealType) {
                ForEach(mealTypes, id:\.self){item in
                    Text(item)
                }
            }
            .pickerStyle(.segmented)
            
            Button {
                model.createCalorieEntry(name: mealTitle, protien: proteinCount, carbs: carbCount, fats: fatCount, mealType: mealType)
                viewState = false
            } label: {
                Text("Add Meal")
                    .frame(maxWidth:.infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding(.vertical)

        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding()
    }
}
