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
                HStack{
                    if let url = postItem.authorProfileURL{
                        WebImage(url: URL(string: url))
                            .resizable()
                            .frame(width:50, height: 50)
                            .cornerRadius(100)
                            .clipped()
                    } else {
                        Circle().fill(.black)
                            .frame(width:50, height: 50)
                            .cornerRadius(100)
                            .clipped()
                    }
                    Text("@\(postItem.authorId)")
                }
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