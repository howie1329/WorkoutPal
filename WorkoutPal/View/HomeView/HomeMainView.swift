//
//  HomeMainView.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 5/10/23.
//

import SwiftUI

struct HomeMainView: View {
    enum SelectionsView: String, CaseIterable {
        case WeekView = "WeekView"
        case DayView = "DayView"
    }
    @EnvironmentObject var model: DataModel
    @State var weekStats = WeekModel(totalCal: 0, protein: 0, carbs: 0, fats: 0, dayInfo: [])
    @State var viewSelector: SelectionsView = .WeekView
    var body: some View {
        NavigationStack {
            HStack{
                Text("Workout Pal")
                    .font(.title)
                    .bold()
            }
            .frame(maxWidth: .infinity,alignment: .leading)
            .padding([.vertical,.horizontal])
            VStack {
                Picker("", selection: $viewSelector) {
                    ForEach(SelectionsView.allCases, id: \.self) { item in
                        Text("\(item.rawValue)")
                    }
                }
                .pickerStyle(.segmented)
                switch viewSelector {
                case .WeekView:
                    WeekView(model: model, weekStats: weekStats)
                case .DayView:
                    DayView()
                }
                Divider()
                if weekStats.dayInfo.isEmpty {
                    Text("No Data")
                } else {
                    VStack {
                        ScrollViewHome(weekStats: weekStats)
                        HomeStatsView(weekData: weekStats)
                    }.padding(.horizontal)
                }
                Spacer()
                Divider()
            }
            .onAppear(perform: {
                weekStats = getWeekStats(currentDate: model.currentDate, foodItem: model.foodItemTrackerLog, dayStats: model.dayLogTrackerLog)
            })
            Spacer()
        }
    }
}

struct HomeMainView_Previews: PreviewProvider {
    static var previews: some View {
        HomeMainView()
            .environmentObject(DataModel())
    }
}
