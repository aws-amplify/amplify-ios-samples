//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Amplify

enum SessionState {
    case signedOut
    case signedIn(_ user: AuthUser)
}
