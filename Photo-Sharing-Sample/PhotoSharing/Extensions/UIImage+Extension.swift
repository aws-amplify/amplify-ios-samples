//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import SwiftUI

extension UIImage {

    func pngFlattened(isOpaque: Bool = true) -> Data? {
        if imageOrientation == .up {
            return self.pngData()
        }

        let format = imageRendererFormat
        format.opaque = isOpaque

        return UIGraphicsImageRenderer(size: size, format: format).image { _ in draw(at: .zero) }.pngData()
    }

}
