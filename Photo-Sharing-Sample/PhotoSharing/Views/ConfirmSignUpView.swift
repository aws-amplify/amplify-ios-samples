//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: MIT-0
//

import SwiftUI
import Amplify

struct ConfirmSignUpView: View {
    @StateObject private var viewModel: ViewModel

    init(username: String, password: String) {
        let model = ViewModel()
        model.user.username = username
        model.user.password = password
        self._viewModel = StateObject(wrappedValue: model)
    }

    var body: some View {
        AuthContainerView(title: "Validate account") {
            Text("We've sent a validation code to your email.\nPlease enter it below.")

            InputField("Validation code", text: $viewModel.confirmationCode)
                .keyboardType(.numberPad)

            LoadingButton(title: "Submit", isLoading: viewModel.isLoading, action: viewModel.confirmSignUp)
                .padding(.top, 10)

            NavigationLink(destination: SignInView(username: viewModel.user.username),
                           when: $viewModel.nextState,
                           equals: .signIn)

            if let error = viewModel.error {
                AuthErrorView(error: error)
            }

            Spacer()
            if case .notAuthorized = viewModel.error {
                Divider()
                NavigationLink(destination: SignInView()) {
                    Text("Go to Login screen").foregroundColor(.orange)
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }
}
