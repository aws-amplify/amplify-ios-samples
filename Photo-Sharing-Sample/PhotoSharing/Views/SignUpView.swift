//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: MIT-0
//

import SwiftUI

struct SignUpView: View {
    @Environment(\.presentationMode) private var presentation
    @StateObject private var viewModel = ViewModel()

    var body: some View {
        AuthContainerView(title: "Create account") {
            InputField("Username", text: $viewModel.user.username)

            InputField("Email address", text: $viewModel.user.email)
                .keyboardType(.emailAddress)

            InputField("Password", text: $viewModel.user.password, isSecure: true)

            LoadingButton(title: "Sign up", isLoading: viewModel.isLoading, action: viewModel.signUp)
                .padding(.top, 10)

            NavigationLink(destination: ConfirmSignUpView(username: viewModel.user.username,
                                                          password: viewModel.user.password),
                           when: $viewModel.nextState,
                           equals: .confirmSignUp)

            if let error = viewModel.error {
                AuthErrorView(error: error)
            }

            Spacer()
            Divider()
            HStack {
                Text("Already have an account?")
                Button(action: {
                    self.presentation.wrappedValue.dismiss()
                }, label: {
                    Text("Sign in").foregroundColor(.orange)
                })
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }
}
