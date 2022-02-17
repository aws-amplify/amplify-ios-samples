//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: MIT-0
//

import SwiftUI

struct SignInView: View {
    @StateObject private var viewModel: ViewModel

    init(username: String = "") {
        let model = ViewModel()
        model.user.username = username
        self._viewModel = StateObject(wrappedValue: model)
    }

    var body: some View {
        AuthContainerView(title: "Login") {
            InputField("Username", text: $viewModel.user.username)

            InputField("Password", text: $viewModel.user.password, isSecure: true)

            LoadingButton(title: "Sign in", isLoading: viewModel.isLoading, action: viewModel.signIn)
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
                Text("Don't have an account?")
                NavigationLink(destination: SignUpView()) {
                    Text("Sign up").foregroundColor(.orange)
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }
}
