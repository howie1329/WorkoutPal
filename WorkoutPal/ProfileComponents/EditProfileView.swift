//
//  EditProfileView.swift
//  WorkoutPal
//
//  Created by Howard Thomas on 6/25/23.
//

import SwiftUI

struct EditProfileView: View {
    @EnvironmentObject var userModel: UserDataModel
    @State var userBio = ""
    @Binding var viewState: Bool
    var body: some View {
        VStack {
            TextField("Bio", text: $userBio)
            Button {
                Task {
                    await userModel.updateBio(newBio: userBio)
                    viewState.toggle()
                }
            } label: {
                Text("Update")
            }
            .buttonStyle(.borderedProminent)

        }
    }
}
