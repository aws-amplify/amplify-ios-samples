//
//  AuthStep.swift
//  PhotoSharingSample
//
//  Created by Villena, Sebastian on 2022-02-09.
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
        case .confirmSignUp(_),
             .confirmSignInWithCustomChallenge(_),
             .confirmSignInWithSMSMFACode(_,_),
             .confirmSignInWithNewPassword(_):
            return .confirmSignUp
        case .resetPassword(_):
            return .resetPassword
        }
    }
}

extension AuthSignUpStep {
    var authStep: AuthStep {
        switch self {
        case .done:
            return .done
        case .confirmUser(_, _):
            return .confirmSignUp
        }
    }
}
