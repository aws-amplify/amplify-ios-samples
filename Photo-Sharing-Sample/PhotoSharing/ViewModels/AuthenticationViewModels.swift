//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: MIT-0
//

import Amplify
import Foundation
import SwiftUI

extension SignInView {

    class ViewModel: AuthenticationViewModel {
        func signIn() async {
            startLoading()
            do {
                let nextStep = try await authService.signIn(
                    username: user.username,
                    password: user.password
                )
                handleNextStep(nextStepResult: nextStep)
            } catch {
                handleError(error: error)
            }
        }
    }
}

extension SignUpView {
    
    class ViewModel: AuthenticationViewModel {
        func signUp() async {
            startLoading()
            do {
                let nextStep = try await authService.signUp(
                    username: user.username,
                    password: user.password,
                    email: user.email
                )
                handleNextStep(nextStepResult: nextStep)
            } catch {
                handleError(error: error)
            }
        }
    }
}

extension ConfirmSignUpView {

    class ViewModel: AuthenticationViewModel {
        func confirmSignUp() async {
            startLoading()
            do {
                let nextStep = try await authService.confirmSignUpAndSignIn(
                    username: user.username,
                    password: user.password,
                    confirmationCode: confirmationCode
                )
                handleNextStep(nextStepResult: nextStep)
            } catch {
                handleError(error: error)
            }
        }
    }
}

class AuthenticationViewModel: ObservableObject {
    class User: ObservableObject {
        @Published var username = ""
        @Published var email = ""
        @Published var password = ""
    }

    let authService: AuthService

    @Published var user = User()
    @Published var confirmationCode = ""
    @Published var isLoading = false
    @Published var error: AuthError?
    @Published var nextState: AuthStep?

    init(manager: ServiceManager = AppServiceManager.shared) {
        self.authService = manager.authService
    }

    func startLoading() {
        nextState = nil
        isLoading = true
        error = nil
    }

    func handleNextStep(nextStepResult: AuthStep) {
        nextState = nextStepResult
    }

    func handleError(error: Error) {
        if let authError = error as? AuthError {
            Amplify.log.error("\(#function) Error: \(error.localizedDescription)")
            self.error = authError
        } else {
            Amplify.log.error("\(#function) Received unknown error: \(error.localizedDescription)")
        }
    }
}
