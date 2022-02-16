//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: MIT-0
//

import Amplify
import Foundation

enum AuthStep {
    case signIn
    case confirmSignUp
    case resetPassword // Not yet supported
    case done
}

extension AuthSignInStep {
    var authStep: AuthStep {
        switch self {
        case .done:
            return .done
        case .confirmSignUp,
             .confirmSignInWithCustomChallenge,
             .confirmSignInWithSMSMFACode,
             .confirmSignInWithNewPassword:
            return .confirmSignUp
        case .resetPassword:
            return .resetPassword
        }
    }
}

extension AuthSignUpStep {
    var authStep: AuthStep {
        switch self {
        case .done:
            return .done
        case .confirmUser:
            return .confirmSignUp
        }
    }
}
