//
//  CalorieRowView.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 5/8/23.
//

import SwiftUI

struct CalorieRowView: View {
    @EnvironmentObject var model: DataModel
    var item: FoodItemEntity
    @Binding var totalCal: Int
    @Binding var proCount: Int
    @Binding var carbCount: Int
    @Binding var fatCount: Int
    var body: some View {
        HStack {
            VStack {
                HStack {
                    Text(item.name ?? "")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                HStack {
                    Text("\(item.protien) g protein")
                    Text("\(item.carb) g carbs")
                    Text("\(item.fat) g fat")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            Spacer()
            VStack {
                Text("\(item.totalCal ) cals")
            }
        }
        .onAppear(perform: {
            totalCal = 0
            proCount = 0
            carbCount = 0
            fatCount = 0
            totalCal += Int(item.totalCal)
            proCount += Int(item.protien)
            carbCount += Int(item.carb)
            fatCount += Int(item.fat)
        })
    }
}
