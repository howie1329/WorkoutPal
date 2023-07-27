//
//  ExploreProfileView.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 7/11/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct ExploreProfileView: View {
    @State var searchUser: UserModel
    @StateObject var profileModel = ExploreProfileViewModel()
    @EnvironmentObject var userModel: UserDataModel
    
    var body: some View {
        VStack{
            VStack{
                HStack{
                    VStack{
                        WebImage(url: URL(string: searchUser.user_profileURL)).placeholder {
                            Circle().fill(Color.black)
                                .frame(width: 50)
                        }
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .cornerRadius(100)
                        .clipped()
                        
                    }
                    Spacer()
                    HStack(spacing:25){
                        VStack{
                            Text("\(profileModel.feed.count)")
                                .bold()
                            Text("Posts")
                        }
                        VStack{
                            Text("\(searchUser.following.count)")
                                .bold()
                            Text("Followers")
                        }
                        VStack{
                            Text("\(searchUser.followed.count)")
                                .bold()
                            Text("Following")
                        }
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment:.leading)
                HStack{
                    Text("\(searchUser.user_name)")
                        .font(.subheadline)
                        .bold()
                    Text("@\(searchUser.user_handle)")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }.frame(maxWidth: .infinity,alignment:.leading)
                HStack{
                    Text("\(searchUser.user_bio )")
                        .font(.body)
                }
                .padding([.top],2)
                .frame(maxWidth: .infinity, alignment:.leading)
                HStack{
                    if userModel.userInfo.followed.contains(searchUser.id!){
                        Button {
                            userModel.unFollow(searchUser)
                        } label: {
                            Text("Unfollow")
                                .font(.subheadline)
                                .bold()
                                .padding(.horizontal, 6)
                        }
                        .tint(.gray)
                        .buttonStyle(.bordered)
                    } else {
                        Button {
                            userModel.follow(searchUser)
                        } label: {
                            Text("Follow")
                                .font(.subheadline)
                                .bold()
                                .padding(.horizontal, 6)
                        }
                        .buttonStyle(.borderedProminent)
                    }

                }
                .frame(maxWidth: .infinity, alignment:.leading)
                
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            Divider()
            ScrollView{
                LazyVStack{
                    ForEach(profileModel.feed){item in
                        PostView(postItem: item)
                        Divider()
                    }
                }
            }
        }
        .onAppear {
            profileModel.fetchProfilePost(user: searchUser)
        }
    }
}

//struct ExploreProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ExploreProfileView(searchUser: UserModel(user_name: "Howard", user_email: "", user_handle: "Second", user_gender: "Male", user_bio: "Bio Here", user_id: "Thomas", user_profileURL: "", liked_post: []))
//    }
//}
