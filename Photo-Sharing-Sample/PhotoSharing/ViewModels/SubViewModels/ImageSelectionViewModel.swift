//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: MIT-0
//

import SwiftUI

extension ImageSelectionView {

    class ViewModel: ObservableObject {

        @Published var presentingView: PresentingView = .imagePicker
        @Published var selectedImage: UIImage?
        @Binding var isPresented: Bool
        let sourceType: ImagePicker.SourceType

        init(isPresented: Binding<Bool>, sourceType: ImagePicker.SourceType) {
            self._isPresented = isPresented
            self.sourceType = sourceType
        }

        func didSelectImage(_ image: UIImage?) {
            if let image = image {
                selectedImage = image
                DispatchQueue.main.async {
                    withAnimation(Animation.default) {
                        self.presentingView = .destinationView
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.isPresented = false
                }
            }
        }
    }

    enum PresentingView {
        case imagePicker
        case destinationView
    }
}
