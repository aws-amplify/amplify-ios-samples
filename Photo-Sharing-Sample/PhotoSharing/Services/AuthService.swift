//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: MIT-0
//

import Amplify
import Combine

protocol AuthService {
    var sessionState: SessionState { get }
    var sessionStatePublisher: Published<SessionState>.Publisher { get }
    var authUser: AuthUser? { get }

    func configure()
    func signIn(username: String, password: String, completion:  @escaping (Result<AuthStep, AuthError>) -> Void)
    func signUp(username: String,
                email: String,
                password: String,
                completion:  @escaping (Result<AuthStep, AuthError>) -> Void)
    func confirmSignUpAndSignIn(username: String,
                                password: String,
                                confirmationCode: String,
                                completion:  @escaping (Result<AuthStep, AuthError>) -> Void)
    func signOut(completion: @escaping (Result<Void, AuthError>) -> Void)
}
