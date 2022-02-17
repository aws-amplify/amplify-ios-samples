//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: MIT-0
//

import SwiftUI

extension ImageSourceSelectionButton {

    class ViewModel: ObservableObject {

        @Published var presentImagePicker = false
        var sourceType: ImagePicker.SourceType = .photoLibrary

        func selectImagePickerSource(_ source: ImagePicker.SourceType) {
            sourceType = source
            presentImagePicker = true
        }
    }
}
