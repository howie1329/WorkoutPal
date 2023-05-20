//
//  HomeScrollView.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 5/17/23.
//

import SwiftUI

struct HomeScrollView: View {
    @EnvironmentObject var model: DataModel
    var body: some View {
        ScrollView(.horizontal){
            HStack{
                ForEach(model.weekDayData, id:\.0){item in
                    Button {
                        model.workoutDataModel.updateDayWorkout(dayNumber: item.0)
                    } label: {
                        VStack(spacing:7){
                            VStack{
                                Text("\(item.0)")
                                    .font(.title)
                                    .bold()
                                Text("\(item.1)")
                                    .font(.headline)
                            }
                            if item.5{
                                Image(systemName: "circle.fill")
                                    .foregroundColor(.green)
                            }else{
                                Image(systemName: "circle.fill")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
        .scrollIndicators(.hidden)
        .padding()
    }
}


struct HomeScrollView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScrollView()
            .environmentObject(DataModel())
    }
}
