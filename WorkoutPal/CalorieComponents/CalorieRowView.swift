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
    @Binding var proCount: Int
    @Binding var carbCount: Int
    @Binding var fatCount: Int
    var body: some View {
        VStack{
            HStack{
                Text(item.name ?? "")
                Text(item.type ?? "")
            }
            HStack{
                Text("Protein: \(item.protien)")
                Text("Carbs: \(item.carb)")
                Text("Fats: \(item.fat)")
            }
        }
        .onAppear(perform:{
            proCount += Int(item.protien)
            carbCount += Int(item.carb)
            fatCount += Int(item.fat)
        })
        .frame(maxWidth:.infinity, alignment:.center)
    }
}
