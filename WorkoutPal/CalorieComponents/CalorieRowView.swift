//
//  CalorieRowView.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 5/8/23.
//

import SwiftUI

struct CalorieRowView: View {
    @EnvironmentObject var model:DataModel
    var item:CalorieTrackerEntity
    @Binding var totalCal: Int
    @Binding var proCount: Int
    @Binding var carbCount: Int
    @Binding var fatCount: Int
    var body: some View {
        VStack{
            VStack{
                HStack{
                    Text(item.name ?? "")
                    Text(item.type ?? "")
                }
                Text("Total Calories: \(item.totalCal ?? 0)")
            }
            HStack{
                Text("Protein: \(item.protien)")
                Text("Carbs: \(item.carb)")
                Text("Fats: \(item.fat)")
            }
        }
        .onAppear(perform:{
            totalCal += Int(item.totalCal)
            proCount += Int(item.protien)
            carbCount += Int(item.carb)
            fatCount += Int(item.fat)
        })
        .frame(maxWidth:.infinity, alignment:.center)
    }
}
