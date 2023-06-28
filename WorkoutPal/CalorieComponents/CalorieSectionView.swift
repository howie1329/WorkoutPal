//
//  CalorieSectionView.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 5/9/23.
//

import SwiftUI

struct CalorieSectionView: View {
    var filterSelection: String
    var foodItem: FoodItemEntity
    @Binding var totalCalories: Int
    @Binding var protienCount: Int
    @Binding var fatCount: Int
    @Binding var carbCount: Int
    var body: some View {
        if foodItem.type == filterSelection {
            Section(header: Text(filterSelection)) {
                CalorieRowView(item: foodItem, totalCal: $totalCalories, proCount: $protienCount, carbCount: $carbCount, fatCount: $fatCount)
            }
        }
    }
}
