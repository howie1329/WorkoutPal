//
//  SignInView.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 5/22/23.
//

import SwiftUI

struct SignInView: View {
    @EnvironmentObject var userModel: UserDataModel
    @State var email: String = ""
    @State var password: String = ""
    var body: some View {
        if userModel.isLoading {
            Text("Loading")
        } else {
            VStack {
                Text("Sign In")
                    .font(.largeTitle.bold())
                Divider()
                VStack(spacing: 20) {
                    TextField("Email", text: $email)
                        .font(.headline)
                    TextField("Password", text: $password)
                        .font(.headline)
                }
                .textFieldStyle(.roundedBorder)
                .padding()
                Divider()
                if email != "" && password != ""{
                    Button {
                        Task {
                            await userModel.emailLogin(email: email, password: password)
                        }
                    } label: {
                        Text("SIGN IN!!")
                            .font(.headline)
                            .frame(maxWidth: .infinity, maxHeight: 35)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.black)
                } else {
                    Button {
                        userModel.errorMessage = userModel.setErrorMessage(errorCode: AuthErrors.failedSignup)
                    } label: {
                        Text("SIGN IN!!")
                            .font(.headline)
                            .frame(maxWidth: .infinity, maxHeight: 35)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.gray)
                }
                Button {
                    Task {
                        await userModel.resetPassword(email: email)
                    }
                } label: {
                    Text("Forgotten Password")
                }

            }
            .alert(userModel.errorMessage, isPresented: $userModel.isError, actions: {})
            .padding()
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
            .environmentObject(UserDataModel())
    }
}
