//
//  SingleWorkoutPlanRowView.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 5/9/23.
//

import SwiftUI

struct SingleWorkoutPlanRowView: View {
    var item:SingleWorkoutEntity
    var body: some View {
        HStack{
            HStack{
                Text(item.workoutTitle ?? "")
            }
            .frame(maxWidth:.infinity, alignment:.leading)
            HStack{
                Text("\(item.sets)")
                Text("•")
                Text("\(item.reps)")
                Text("•")
                Text("\(item.weight) lbs")
            }
            .frame(maxWidth:.infinity, alignment:.trailing)
        }
    }
}
