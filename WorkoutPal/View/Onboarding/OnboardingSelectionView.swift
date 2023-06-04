//
//  OnboardingSelectionView.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 5/22/23.
//

import SwiftUI

struct OnboardingSelectionView: View {
    @EnvironmentObject var userModel:UserDataModel
    enum boardingChoice:String, CaseIterable{
        case signIn = "signin"
        case signUp = "signup"
    }
    @State var userChoice:boardingChoice = .signIn
    var body: some View {
        VStack(){
            Spacer()
            Picker("", selection: $userChoice) {
                ForEach(boardingChoice.allCases, id:\.self){item in
                    Text("\(item.rawValue.uppercased())")
                }
            }
            .pickerStyle(.segmented)
            Spacer()
            if userChoice == .signUp{
                SignUpView()
            }else if userChoice == .signIn{
                SignInView()
            }
            Spacer()
            Spacer()
        }
        .padding()
    }
}

struct OnboardingSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingSelectionView()
            .environmentObject(UserDataModel())
    }
}
