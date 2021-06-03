//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Amplify

extension OnBoardingView {

    class ViewModel: ObservableObject {

        @Published var hasError = false
        @Published var photoSharingError: AmplifyError?

        var authService: AuthService

        init(manager: ServiceManager = AppServiceManager.shared) {
            self.authService = manager.authService
        }

        func signIn() {
            self.authService.webSignIn {
                switch $0 {
                case .success:
                    return
                case .failure(let error):
                    Amplify.log.error("\(#function) Error signing in - \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        self.photoSharingError = error
                        self.hasError = true
                    }
                }
            }
        }
    }
}
