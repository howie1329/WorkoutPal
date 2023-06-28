//
//  StatsRectangleView.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 5/19/23.
//

import SwiftUI

struct StatsRectangleView: View {
    @State var itemData: dayModel
    var body: some View {
        ZStack{
            VStack{
                Text("\(itemData.date.formatted(date: .abbreviated, time: .omitted))")
                    .font(.title2)
                Text("\(itemData.totalCal) cals")
                HStack{
                    Text("\(itemData.protein)g")
                    Text("\(itemData.fats)g")
                    Text("\(itemData.carbs)g")
                }
            }
        }
        .frame(width:200,height: 120)
        .background(Color.gray)
        .cornerRadius(20)
    }
}
