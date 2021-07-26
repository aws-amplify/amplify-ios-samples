//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: MIT-0
//

import SwiftUI

extension UIApplication {
    static func hideKeyboard() {
        UIApplication
            .shared
            .sendAction(#selector(UIResponder.resignFirstResponder),
                        to: nil,
                        from: nil,
                        for: nil)
    }
}
