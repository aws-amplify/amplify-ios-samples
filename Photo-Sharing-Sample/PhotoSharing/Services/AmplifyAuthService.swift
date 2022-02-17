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

    @Published private(set) var sessionState: SessionState = .unknown
    var sessionStatePublisher: Published<SessionState>.Publisher { $sessionState }
    var authUser: AuthUser?
    var subscribers = Set<AnyCancellable>()

    init() {}

    func configure() {
        fetchAuthSession()
    }

    private func fetchAuthSession(completion: (() -> Void)? = nil) {
        Amplify.Auth.fetchAuthSession { result in
            guard let session = try? result.get() as? AWSAuthCognitoSession,
                  let user = session.getUser() else {
                      self.authUser = nil
                      self.sessionState = .signedOut
                      completion?()
                      return
                  }

            self.authUser = user
            self.sessionState = .signedIn(user)
            self.observeAuthEvents()
            completion?()
        }
    }

    func signIn(username: String, password: String, completion:  @escaping (Result<AuthStep, AuthError>) -> Void) {
        _ = Amplify.Auth.signIn(username: username, password: password) { result in
            switch result {
            case .success(let result):
                self.fetchAuthSession {
                    completion(.success(result.nextStep.authStep))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func signUp(username: String,
                email: String,
                password: String,
                completion:  @escaping (Result<AuthStep, AuthError>) -> Void) {
        let emailAttribute = AuthUserAttribute(.email, value: email)
        let options = AuthSignUpRequest.Options(userAttributes: [emailAttribute])
        _ = Amplify.Auth.signUp(username: username, password: password, options: options) { result in
            switch result {
            case .success(let result):
                completion(.success(result.nextStep.authStep))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func confirmSignUpAndSignIn(username: String,
                                password: String,
                                confirmationCode: String,
                                completion:  @escaping (Result<AuthStep, AuthError>) -> Void) {
        _ = Amplify.Auth.confirmSignUp(for: username, confirmationCode: confirmationCode) { result in
            switch result {
            case .success(let result):
                if password.isEmpty {
                    completion(.success(.signIn))
                } else if result.isSignUpComplete {
                    self.signIn(username: username, password: password, completion: completion)
                } else {
                    completion(.success(.signIn))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func signOut(completion: @escaping (Result<Void, AuthError>) -> Void) {
        _ = Amplify.Auth.signOut { result in
            switch result {
            case .success:
                self.authUser = nil
                self.sessionState = .signedOut
                completion(.successfulVoid)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func observeAuthEvents() {
        Amplify.Hub.publisher(for: .auth)
            .sink { payload in
                switch payload.eventName {
                case HubPayload.EventName.Auth.sessionExpired:
                    self.fetchAuthSession()
                default:
                    break
                }
            }
            .store(in: &subscribers)
    }
}
