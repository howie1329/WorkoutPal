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
    @EnvironmentObject var feedModel: FeedDataModel
    @State var editView = false
    var userHandle: String
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                /// Display Profile Picture
                WebImage(url: URL(string: userModel.userUrl )).placeholder(content: {
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
                        Text("200")
                            .bold()
                        Text("Followers")
                    }
                    VStack {
                        Text("1,000")
                            .bold()
                        Text("Following")
                    }
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .center)
            HStack {
                Text("\(userModel.userHandle)")
                    .bold()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            HStack {
                Text("\(userModel.userBio)")
                    .font(.body)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            HStack {
                Button {
                    editView.toggle()
                } label: {
                    Text("Edit Profile")
                        .font(.system(size: 15))
                        .bold()
                        .padding(.horizontal)
                }
                .tint(.gray)
                .buttonStyle(.borderedProminent)
            }
            .frame(maxWidth: .infinity, alignment: .center)
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
        ProfileHeaderComp(userHandle: "HWT03")
            .environmentObject(UserDataModel())
    }
}
