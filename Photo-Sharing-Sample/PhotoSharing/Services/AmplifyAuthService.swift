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
        self.fetchAuthSession()
    }

    func fetchAuthSession() {
        Amplify.Auth.fetchAuthSession { result in
            switch result {
            case .success(let session):
                if let session = session as? AWSAuthCognitoSession {
                    let cognitoTokensResult = session.getCognitoTokens()
                    switch cognitoTokensResult {
                    case .success:
                        break
                    case .failure(let error):
                        self.authUser = nil
                        self.sessionState = .signedOut
                        self.observeAuthEvents()
                        Amplify.log.error("\(error.localizedDescription)")
                        return
                    }
                }

                guard let user = Amplify.Auth.getCurrentUser() else {
                    self.authUser = nil
                    self.sessionState = .signedOut
                    self.observeAuthEvents()
                    return
                }

                self.authUser = user
                self.sessionState = .signedIn(user)
                self.observeAuthEvents()
            case .failure:
                self.authUser = nil
                self.sessionState = .signedOut
            }
        }
    }

    private var window: UIWindow {
        guard
            let scene = UIApplication.shared.connectedScenes.first,
            let windowSceneDelegate = scene.delegate as? UIWindowSceneDelegate,
            let window = windowSceneDelegate.window as? UIWindow
        else { return UIWindow() }

        return window
    }

    func webSignIn(completion: @escaping (Result<Void, AuthError>) -> Void) {
        _ = Amplify.Auth.signInWithWebUI(presentationAnchor: window,
                                         options: .preferPrivateSession()) { result in
            switch result {
            case .success:
                guard let user = Amplify.Auth.getCurrentUser() else {
                    self.authUser = nil
                    self.sessionState = .signedOut
                    return
                }

                self.authUser = user
                self.sessionState = .signedIn(user)
                completion(.successfulVoid)
            case .failure(let error):
                if case .service(_, _, let underlyingError) = error,
                   case .userCancelled = (underlyingError as? AWSCognitoAuthError) {
                    return
                } else {
                    completion(.failure(error))
                }
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
