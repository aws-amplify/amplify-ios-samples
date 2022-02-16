//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: MIT-0
//

import Foundation
import Combine

class LicenseViewModel: ObservableObject {
    let license: String

    init() {
        if let filepath = Bundle.main.path(forResource: "LICENSE", ofType: "") {
            self.license = (try? String(contentsOfFile: filepath)) ?? "Could not load license!"
        } else {
            self.license = "License not found!"
        }
    }
}
