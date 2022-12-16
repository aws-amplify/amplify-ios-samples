//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: MIT-0
//

import Amplify
import AWSCognitoAuthPlugin
import SwiftUI
import Combine

class AmplifyAuthService: AuthService {

    @Published private(set) var sessionState: SessionState = .signedOut
    var sessionStatePublisher: Published<SessionState>.Publisher { $sessionState }
    var authUser: AuthUser?
    var subscribers = Set<AnyCancellable>()

    init() {}

    func configure() {
        Task {
            await fetchAuthSession()
        }
    }

    private func fetchAuthSession() async {
        do {
            let result = try await Amplify.Auth.fetchAuthSession()
            if let session = result as? AWSAuthCognitoSession {
                let cognitoTokensResult = session.getCognitoTokens()
                switch cognitoTokensResult {
                case .success:
                    break
                case .failure(let error):
                    authUser = nil
                    sessionState = .signedOut
                    observeAuthEvents()
                    Amplify.log.error("\(error.localizedDescription)")
                    return
                }
            }
            await updateCurrentUser()
            observeAuthEvents()
        } catch {
            authUser = nil
            sessionState = .signedOut
        }
    }

    func signIn(username: String, password: String) async throws -> AuthStep {
        let result = try await Amplify.Auth.signIn(username: username, password: password)
        await updateCurrentUser()
        return result.nextStep.authStep
    }

    func signUp(username: String,
                password: String,
                email: String
    ) async throws -> AuthStep {
        let emailAttribute = AuthUserAttribute(.email, value: email)
        let options = AuthSignUpRequest.Options(userAttributes: [emailAttribute])
        let result = try await Amplify.Auth.signUp(username: username,
                                                   password: password,
                                                   options: options)
        return result.nextStep.authStep
    }

    func confirmSignUpAndSignIn(username: String,
                                password: String,
                                confirmationCode: String) async throws -> AuthStep {
        let result = try await Amplify.Auth.confirmSignUp(
            for: username,
            confirmationCode: confirmationCode)
        if password.isEmpty {
            return .signIn
        } else if result.isSignUpComplete {
            return try await signIn(username: username, password: password)
        } else {
            return .signIn
        }

    }

    func signOut() async throws {
        let result = await Amplify.Auth.signOut()
        guard let signOutResult = result as? AWSCognitoSignOutResult
        else {
            print("Signout failed")
            return
        }

        switch signOutResult {
        case .failed(let error):
            throw error
        default:
            authUser = nil
            sessionState = .signedOut
        }
    }

    func observeAuthEvents() {
        Amplify.Hub.publisher(for: .auth)
            .sink { payload in
                switch payload.eventName {
                case HubPayload.EventName.Auth.sessionExpired:
                    Task {
                        await self.fetchAuthSession()
                    }
                default:
                    break
                }
            }
            .store(in: &subscribers)
    }

    private func updateCurrentUser() async {
        do {
            let user = try await Amplify.Auth.getCurrentUser()
            authUser = user
            sessionState = .signedIn(user)
        } catch {
            authUser = nil
            sessionState = .signedOut
        }
    }
}
