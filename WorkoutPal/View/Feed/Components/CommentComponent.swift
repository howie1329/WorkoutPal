//
//  CommentComponent.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 7/11/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct CommentComponent: View {
    @State var comment: Comment
    var body: some View {
        VStack {
            HStack {
                WebImage(url: URL(string: comment.author_Url )).placeholder(content: {
                    Circle()
                        .fill(.black)
                        .frame(width: 50, height: 50)
                        .cornerRadius(100)
                })
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 50, height: 50)
                .cornerRadius(100)
                .clipped()
                Text("@\(comment.author_handle)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            HStack {
                Text(comment.message)
                    .font(.subheadline)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            HStack {
                Text(comment.date.dateValue().formatted(date: .abbreviated, time: .shortened))
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .font(.caption)
            .foregroundColor(.gray)
            Divider()
        }
        .padding()
    }
}

struct CommentComponent_Previews: PreviewProvider {
    static var previews: some View {
        CommentComponent(comment: Comment(author_Id: "Thomas", author_handle: "Thomas", message: "Comment", author_Url: ""))
    }
}
