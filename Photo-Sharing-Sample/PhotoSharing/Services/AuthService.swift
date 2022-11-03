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

    func configure() async
    func signIn(username: String, password: String) async throws -> AuthStep
    func signUp(username: String,
                password: String,
                email: String) async throws -> AuthStep
    func confirmSignUpAndSignIn(username: String,
                                password: String,
                                confirmationCode: String) async throws -> AuthStep
    func signOut() async throws
}
