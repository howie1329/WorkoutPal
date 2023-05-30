//
//  ProfleHeaderComp.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 5/23/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfileHeaderComp: View {
    @EnvironmentObject var userModel:UserDataModel
    var userHandle:String
    var body: some View {
        VStack(spacing:0){
            HStack{
                Text("@\(userModel.userHandle)")
            }.frame(maxWidth: .infinity,alignment:.leading)
            HStack(spacing:50){
                WebImage(url: URL(string: userModel.userUrl )).placeholder(content: {
                    Circle()
                        .fill(.black)
                        .frame(width:50, height: 50)
                        .cornerRadius(100)
                        .clipped()
                })
                .resizable()
                .frame(width:50, height: 50)
                .cornerRadius(100)
                .clipped()
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
                Button {
                    userModel.signOutUser()
                } label: {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                }
                
            }
            .frame(maxWidth: .infinity,alignment:.leading)
        }.padding([.horizontal])
    }
}

struct ProfleHeaderComp_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHeaderComp(userHandle: "HWT03")
            .environmentObject(UserDataModel())
    }
}
