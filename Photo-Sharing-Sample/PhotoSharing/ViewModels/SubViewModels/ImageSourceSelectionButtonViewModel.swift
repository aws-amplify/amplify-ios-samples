//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import SwiftUI

extension ImageSourceSelectionButton {

    class ViewModel: ObservableObject {

        @Published var presentImagePicker = false
        var sourceType: ImagePicker.SourceType = .photoLibrary

        func selectImagePickerSource(_ source: ImagePicker.SourceType) {
            self.sourceType = source
            self.presentImagePicker = true
        }
    }
}
