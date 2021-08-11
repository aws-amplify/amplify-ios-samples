//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: MIT-0
//

import SwiftUI

struct ImageSelectionView<DestinationView: View>: View {

    @StateObject private var viewModel: ViewModel
    let destinationView: (UIImage) -> DestinationView

    init(isPresented: Binding<Bool>,
         sourceType: ImagePicker.SourceType,
         @ViewBuilder destinationView: @escaping (UIImage) -> DestinationView) {
        self._viewModel = StateObject(wrappedValue: ViewModel(isPresented: isPresented,
                                                              sourceType: sourceType))
        self.destinationView = destinationView
    }

    var body: some View {
        switch viewModel.presentingView {
        case .imagePicker:
            ImagePicker(sourceType: viewModel.sourceType,
                        completionHandler: viewModel.didSelectImage(_:))
                .ignoresSafeArea()
                .transition(.asymmetric(insertion: .move(edge: .leading),
                                        removal: .move(edge: .trailing)))
        case .destinationView:
            if let image = viewModel.selectedImage {
                destinationView(image)
            }
        }
    }
}

struct ImageSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        ImageSelectionView(
            isPresented: Binding.constant(true),
            sourceType: .photoLibrary,
            destinationView: { selectedImage in Image(uiImage: selectedImage)}
        )
    }
}
