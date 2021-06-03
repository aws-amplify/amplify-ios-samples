//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Amplify

protocol AuthService {
    var sessionState: SessionState { get }
    var sessionStatePublisher: Published<SessionState>.Publisher { get }
    var authUser: AuthUser? { get }

    func configure()
    func signOut(completion: @escaping (Result<Void, AuthError>) -> Void)
    func webSignIn(completion: @escaping (Result<Void, AuthError>) -> Void)
}
