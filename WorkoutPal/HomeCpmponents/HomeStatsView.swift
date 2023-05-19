//
//  HomeStatsView.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 5/19/23.
//

import SwiftUI

struct HomeStatsView: View {
    @EnvironmentObject var model:DataModel
    var body: some View {
        ScrollView(.horizontal){
            HStack{
                StatsRectangleView(itemData: model.weekDayData[1])
                StatsRectangleView(itemData: model.weekDayData[2])
                StatsRectangleView(itemData: model.weekDayData[3])
            }
            HStack{
                StatsRectangleView(itemData: model.weekDayData[4])
                StatsRectangleView(itemData: model.weekDayData[5])
                StatsRectangleView(itemData: model.weekDayData[6])
            }
        }
        .scrollIndicators(.hidden)
        .padding()
    }
}

struct HomeStatsView_Previews: PreviewProvider {
    static var previews: some View {
        HomeStatsView()
            .environmentObject(DataModel())
    }
}
