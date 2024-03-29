//
//  SignUpView.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 5/22/23.
//

import SwiftUI
import _PhotosUI_SwiftUI

struct SignUpView: View {
    @EnvironmentObject var userModel: UserDataModel
    @State var name: String = ""
    @State var handle: String = ""
    @State var gender: UserGenderID = .none
    @State var bio: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var confirmPassword: String = ""
    @State var showSiginUp = false
    var body: some View {
        if userModel.isLoading {
            Text("Loading")
        } else {
            VStack {
                Text("Sign Up")
                    .font(.largeTitle.bold())
                Divider()
                VStack(spacing: 15) {
                    PhotosPicker(selection: $userModel.userPickerImage, matching: .images) {
                        if userModel.userProfilePhoto == nil {
                            Image(systemName: "person.circle")
                                .resizable()
                                .foregroundColor(Color(.systemGray3))
                                .frame(maxWidth: 50, maxHeight: 50)
                        } else {
                            if let image = userModel.userProfilePhoto {
                                Image(uiImage: image)
                                    .resizable()
                                    .frame(maxWidth: 50, maxHeight: 50)
                                    .cornerRadius(100)
                                    .aspectRatio(contentMode: .fill)
                            }
                        }
                    }
                    .onChange(of: userModel.userPickerImage) { _ in
                        Task {
                            await userModel.getProfilePhoto()
                        }
                    }
                    ScrollView {
                        TextField("Name", text: $name)
                            .font(.subheadline)
                            .padding(12)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                        TextField("@Handle", text: $handle)
                            .font(.subheadline)
                            .padding(12)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                        Picker("Gender", selection: $gender) {
                            ForEach(UserGenderID.allCases, id: \.self) {
                                Text($0.rawValue)
                            }
                        }
                        .pickerStyle(.segmented)
                        TextField("Bio", text: $bio,axis: .vertical)
                            .font(.subheadline)
                            .padding(12)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                        TextField("Email", text: $email)
                            .font(.subheadline)
                            .padding(12)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                        SecureField("Password", text: $password)
                            .font(.subheadline)
                            .padding(12)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                        SecureField("Comfirm Password", text: $confirmPassword)
                            .font(.subheadline)
                            .padding(12)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                    }
                    .frame(maxWidth: .infinity)
                }
                Divider()
                if showSiginUp {
                    Button {
                        Task {
                            var userInfo = UserModel(user_name: name, user_email: email, user_handle: handle, user_gender: gender.rawValue, user_bio: bio, user_id: "", user_profileURL: "",liked_post: [], followed: [], following: [])
                            await userModel.emailSignUp(user: userInfo, password: password)
                        }
                    } label: {
                        Text("SIGN UP!!")
                            .font(.headline)
                            .frame(maxWidth: .infinity, maxHeight: 35)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.black)
                } else {
                    Button {
                        userModel.errorMessage = userModel.setErrorMessage(errorCode: AuthErrors.failedSignup)
                    } label: {
                        Text("SIGN UP!!")
                            .font(.headline)
                            .frame(maxWidth: .infinity, maxHeight: 30)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color(.systemGray3))
                }
            }
            .alert(userModel.errorMessage, isPresented: $userModel.isError, actions: {})
            .onChange(of: confirmPassword, perform: { _ in
                showSiginUp = try! userModel.checkingSignupValidation(email: email, password: password, confirm: confirmPassword, handle: handle, name: name)
            })
            .padding()
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
            .environmentObject(UserDataModel())
    }
}
