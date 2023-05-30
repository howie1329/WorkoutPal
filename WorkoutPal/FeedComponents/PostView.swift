//
//  PostView.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 5/29/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct PostView: View {
    let postItem: MessageFeed
    var body: some View {
        VStack{
            HStack{
                Text("@\(postItem.authorId)")
                //WebImage(url: URL(string: postItem.authorProfileURL))
                Spacer()
                Text("\(postItem.date.dateValue().formatted(date: .abbreviated, time: .shortened))")
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth:.infinity,alignment: .leading)
            .font(.footnote.bold())
            .foregroundColor(.gray)
            
            if let image = postItem.mediaURL{
                WebImage(url: URL(string: image))
                    .resizable()
                    .frame(maxWidth: .infinity,maxHeight: 200)
            }
            HStack{
                Text(postItem.body)
            }.frame(maxWidth:.infinity,alignment:.center)
        }
    }
}
