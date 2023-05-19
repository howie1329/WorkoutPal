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
                ForEach(model.weekDayData, id:\.0){item in
                    StatsRectangleView(itemData: item)
                }
            }
        }
    }
}

struct HomeStatsView_Previews: PreviewProvider {
    static var previews: some View {
        HomeStatsView()
            .environmentObject(DataModel())
    }
}
