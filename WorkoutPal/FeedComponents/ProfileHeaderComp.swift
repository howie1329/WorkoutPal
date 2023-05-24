//
//  ProfleHeaderComp.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 5/23/23.
//

import SwiftUI

struct ProfileHeaderComp: View {
    @EnvironmentObject var userModel:UserDataModel
    var userHandle:String
    var body: some View {
        VStack(spacing:0){
            HStack{
                Text("@\(userModel.userHandle)")
            }.frame(maxWidth: .infinity,alignment:.leading)
            HStack(spacing:50){
                Circle().frame(maxWidth:50)
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
        }
    }
}

struct ProfleHeaderComp_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHeaderComp(userHandle: "HWT03")
            .environmentObject(UserDataModel())
    }
}
