//
//  StatsRectangleView.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 5/19/23.
//

import SwiftUI

struct StatsRectangleView: View {
    @State var itemData: (Int,Int,Int,Int,Int,Bool)
    var body: some View {
        ZStack{
            VStack{
                Text("\(itemData.0)")
                    .font(.title2)
                Text("\(itemData.1) cals")
                HStack{
                    Text("\(itemData.2)g")
                    Text("\(itemData.3)g")
                    Text("\(itemData.4)g")
                }
            }
        }
        .frame(width:182,height: 90)
        .background(Color.gray)
        .cornerRadius(20)
    }
}

struct StatsRectangleView_Previews: PreviewProvider {
    static var previews: some View {
        StatsRectangleView(itemData: (0,1,100,200,300,true))
    }
}
