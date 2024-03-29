//
//  ProfleHeaderComp.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 5/23/23.
//

import SwiftUI
import SDWebImageSwiftUI

/// The Header for the profile view
struct ProfileHeaderComp: View {
    @EnvironmentObject var userModel: UserDataModel
    @EnvironmentObject var feedModel: FeedViewModel
    @State var editView = false
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                /// Display Profile Picture
                WebImage(url: URL(string: userModel.userInfo.user_profileURL )).placeholder(content: {
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
                Spacer()
                HStack(spacing: 25) {
                    VStack {
                        Text("\(feedModel.yourPost.count)")
                            .bold()
                        Text("Posts")
                    }
                    VStack {
                        Text("\(userModel.userInfo.following.count)")
                            .bold()
                        Text("Followers")
                    }
                    VStack {
                        Text("\(userModel.userInfo.followed.count)")
                            .bold()
                        Text("Following")
                    }
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .center)
            HStack {
                Text("\(userModel.userInfo.user_name)")
                    .font(.subheadline)
                    .bold()
                Text("@\(userModel.userInfo.user_handle)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            HStack {
                Text("\(userModel.userInfo.user_bio )")
                    .font(.body)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            HStack {
                Button {
                    editView.toggle()
                } label: {
                    Text("Edit Profile")
                        .font(.subheadline)
                        .bold()
                        .padding(.horizontal, 6)
                }
                .tint(.gray)
                .buttonStyle(.borderedProminent)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .sheet(isPresented: $editView, content: {
            EditProfileView(viewState: $editView)
        })
        .toolbar {
            /// Sign out button
            ToolbarItem {
                Button {
                    userModel.signOutUser()
                } label: {
                    Text("Log Out")
                }
            }
        }
        .padding([.horizontal])
    }
}

struct ProfleHeaderComp_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHeaderComp()
            .environmentObject(UserDataModel())
    }
}
