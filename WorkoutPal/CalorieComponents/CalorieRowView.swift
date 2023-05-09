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
        HStack{
            VStack{
                HStack{
                    Text(item.name ?? "")
                }
                HStack{
                    Text("\(item.protien) g protein")
                    Text("\(item.carb) g carbs")
                    Text("\(item.fat) g fat")
                }
            }
            Spacer()
            VStack{
                Text("\(item.totalCal ) cals")
            }
        }
        .onAppear(perform:{
            totalCal += Int(item.totalCal)
            proCount += Int(item.protien)
            carbCount += Int(item.carb)
            fatCount += Int(item.fat)
        })
        .frame(maxWidth:.infinity)
    }
}
