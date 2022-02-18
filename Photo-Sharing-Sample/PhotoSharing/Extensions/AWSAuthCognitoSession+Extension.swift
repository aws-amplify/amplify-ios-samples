//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: MIT-0
//

import Amplify
import AWSCognitoAuthPlugin
import AWSPluginsCore
import Foundation

private class PhotoSharingUser: AuthUser {
    let username: String
    let userId: String

    init(username: String, userId: String) {
        self.username = username
        self.userId = userId
    }
}

extension AWSAuthCognitoSession {
    // Temp workaround until Auth.getCurrentUser() is implemented, which returns these values.
    func getUser() -> AuthUser? {
        let userSub = try? userSubResult.get()
        guard let idToken = try? cognitoTokensResult.get().idToken,
              let tokenClaims = try? AWSAuthService().getTokenClaims(tokenString: idToken).get(),
              let username = tokenClaims["cognito:username"] as? String,
              let userId = userSub ?? tokenClaims["sub"] as? String else {
            return nil
        }

        return PhotoSharingUser(username: username, userId: userId)
    }
}
