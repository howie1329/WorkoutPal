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
    @EnvironmentObject var userModel:UserDataModel
    var userHandle:String
    var body: some View {
        HStack{
            VStack{
                // MARK: Display Profile Picture
                WebImage(url: URL(string: userModel.userUrl )).placeholder(content: {
                    Circle()
                        .fill(.black)
                        .frame(width:50, height: 50)
                        .cornerRadius(100)
                })
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width:50, height: 50)
                .cornerRadius(100)
                .clipped()
                Text("@\(userModel.userHandle)")
            }
            HStack(spacing:50){
                VStack{
                    Text("200")
                        .bold()
                    Text("Followers")
                }
                VStack{
                    Text("1,000")
                        .bold()
                    Text("Following")
                }
            }
            .frame(maxWidth: .infinity,alignment:.leading)
        }
        .toolbar{
            // MARK: Sign out button
            ToolbarItem{
                Button {
                    userModel.signOutUser()
                } label: {
                    Text("Log Out")
                    Image(systemName: "rectangle.portrait.and.arrow.right")
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
