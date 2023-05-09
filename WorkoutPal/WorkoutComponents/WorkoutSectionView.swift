//
//  WorkoutSectionView.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 5/9/23.
//

import SwiftUI

struct WorkoutSectionView: View {
    var filerSection:String
    var singleWorkoutItem: SingleWorkoutEntity
    var body: some View {
        if filerSection == singleWorkoutItem.focusGroup{
            Section(header:Text(filerSection)){
                SingleWorkoutPlanRowView(item: singleWorkoutItem)
            }
        }
    }
}
