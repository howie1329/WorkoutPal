//
//  FeedMainHeader.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 7/11/23.
//

import SwiftUI

struct FeedMainHeader: View {
    @Binding var explorePageViewState: Bool
    var body: some View {
        Button {
            explorePageViewState.toggle()
        } label: {
            Image(systemName: "magnifyingglass")
                .bold()
        }
        .buttonStyle(.plain)
        Image(systemName: "message")
            .bold()
        Image(systemName: "bell")
            .bold()
    }
}
