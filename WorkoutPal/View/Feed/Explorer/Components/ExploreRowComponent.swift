//
//  ExploreRowComponent.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 7/11/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct ExploreRowComponent: View {
    var user: UserModel
    var body: some View {
        HStack{
            WebImage(url: URL(string: user.user_profileURL))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 50, height: 50)
                .cornerRadius(100)
                .clipped()
            Text("@\(user.user_handle)")
                .bold()
        }
        .frame(maxWidth: .infinity,alignment: .leading)
        .padding([.horizontal])
        Divider()
    }
}
