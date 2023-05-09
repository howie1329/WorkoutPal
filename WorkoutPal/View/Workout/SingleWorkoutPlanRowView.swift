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
        VStack{
            HStack{
                Text(item.workoutTitle ?? "")
                Text("Focus: \(item.focusGroup ?? "")")
            }
            HStack{
                Text("Reps: \(item.reps)")
                Text("Sets: \(item.sets)")
                Text("Weight: \(item.weight)")
            }
        }
        .frame(maxWidth:.infinity, alignment:.center)
    }
}
