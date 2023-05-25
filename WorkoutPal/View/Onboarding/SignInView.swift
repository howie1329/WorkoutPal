//
//  SignInView.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 5/22/23.
//

import SwiftUI

struct SignInView: View {
    @EnvironmentObject var userModel:UserDataModel
    @State var email:String = ""
    @State var password:String = ""
    var body: some View {
        VStack{
            Text("Sign In")
                .font(.largeTitle.bold())
            Divider()
            VStack(spacing:15){
                TextField("Email", text: $email)
                TextField("Password", text: $password)
            }
            .textFieldStyle(.roundedBorder)
            .padding()
            Divider()
            if email != "" && password != ""{
                Button {
                    userModel.emailLogin(email: email, password: password)
                } label: {
                    Text("Sign In!!")
                        .frame(maxWidth:.infinity, maxHeight: 35)
                }
                .buttonStyle(.borderedProminent)
                .tint(.black)
            }else{
                Button {
                    //
                } label: {
                    Text("Sign In!!")
                        .frame(maxWidth: .infinity, maxHeight: 35)
                }
                .buttonStyle(.borderedProminent)
                .tint(.black)
                .opacity(0.75)

            }
        }
        .padding()
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
            .environmentObject(UserDataModel())
    }
}