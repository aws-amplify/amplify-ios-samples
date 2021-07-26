//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Amplify

public enum PhotoSharingError: Error {
    case model(ErrorDescription, RecoverySuggestion, Error? = nil)
}

extension PhotoSharingError: AmplifyError {

    public var errorDescription: ErrorDescription {
        switch self {
        case .model(let errorDescription, _, _):
            return errorDescription
        }
    }

    public var recoverySuggestion: RecoverySuggestion {
        switch self {
        case .model(_, let recoverySuggestion, _):
            return recoverySuggestion
        }
    }

    public var underlyingError: Error? {
        switch self {
        case .model(_, _, let underlyingError):
            return underlyingError
        }
    }

    public init(errorDescription: ErrorDescription = "An unknown error occurred",
                recoverySuggestion: RecoverySuggestion = "See `underlyingError` for more details",
                error: Error) {
        self = .model(errorDescription, recoverySuggestion, error)
    }
}
