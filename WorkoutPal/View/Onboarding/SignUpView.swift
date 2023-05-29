//
//  SignUpView.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 5/22/23.
//

import SwiftUI
import _PhotosUI_SwiftUI

struct SignUpView: View {
    @EnvironmentObject var userModel:UserDataModel
    
    @State var name:String = ""
    @State var handle:String = ""
    @State var gender:userGenderID = .none
    @State var email:String = ""
    @State var password:String = ""
    @State var confirmPassword:String = ""
    var body: some View {
        if userModel.isLoading {
            LoadingView()
        }else{
            VStack{
                Text("Sign Up")
                    .font(.largeTitle.bold())
                Divider()
                VStack(spacing:15){
                    PhotosPicker(selection:$userModel.userPickerImage, matching:.images){
                        if userModel.userProfilePhoto == nil{
                            Image(systemName: "person.circle")
                                .resizable()
                                .frame(maxWidth: 50,maxHeight:50)
                        }else{
                            if let image = userModel.userProfilePhoto{
                                Image(uiImage: image)
                                    .resizable()
                                    .frame(maxWidth: 100,maxHeight:100)
                                    .cornerRadius(100)
                                    .aspectRatio(contentMode: .fill)
                            }
                        }
                        
                    }
                    .onChange(of: userModel.userPickerImage) { newValue in
                        Task{
                            await userModel.getProfilePhoto()
                        }
                    }
                    TextField("Name", text: $name)
                    TextField("@Handle",text:$handle)
                    
                    
                    Picker("Gender", selection: $gender) {
                        ForEach(userGenderID.allCases, id:\.self){
                            Text($0.rawValue)
                            
                        }
                    }
                    .pickerStyle(.segmented)
                    TextField("Email", text: $email)
                    TextField("Password", text: $password)
                    TextField("Comfirm Password", text: $confirmPassword)
                }
                .textFieldStyle(.roundedBorder)
                .padding()
                Divider()
                if email != "" && password != "" && name != ""{
                    if password == confirmPassword{
                        Button {
                            Task{
                                await userModel.emailSignUp(name: name, email: email, password: password, gender: gender, handle: handle)
                            }
                            
                        } label: {
                            Text("Sign Up!!")
                                .frame(maxWidth:.infinity, maxHeight: 35)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.black)
                        
                    }
                }else{
                    Button {
                        //
                    } label: {
                        Text("Sign Up!!")
                            .frame(maxWidth: .infinity, maxHeight: 30)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.black)
                    .opacity(0.75)
                    
                }
            }
            .alert(userModel.errorMessage, isPresented: $userModel.isError, actions: {})
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
