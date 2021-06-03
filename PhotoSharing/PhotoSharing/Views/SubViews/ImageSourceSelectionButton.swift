//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import SwiftUI

struct ImageSourceSelectionButton<DisplayView: View, DestinationView: View>: View {

    @StateObject private var viewModel = ImageSourceSelectionButton.ViewModel()
    @State private var showSheet = false

    let displayView: DisplayView
    let destinationView: (UIImage) -> DestinationView

    init(@ViewBuilder displayView: () -> DisplayView,
         @ViewBuilder destinationView: @escaping (UIImage) -> DestinationView) {
        self.displayView = displayView()
        self.destinationView = destinationView
    }

    var body: some View {
        VStack {
            self.displayView
        }
        .onTapGesture {
            self.showSheet = true
        }
        .actionSheet(isPresented: $showSheet) {
            ActionSheet(
                title: Text("Select Photo"),
                message: Text("Choose from following"),
                buttons: [
                    .default(Text("Photo Library")) {
                        self.viewModel.selectImagePickerSource(.photoLibrary)
                    },
                    .default(Text("Camera")) {
                        self.viewModel.selectImagePickerSource(.camera)
                    },
                    .cancel()
                ]
            )
        }
        .fullScreenCover(isPresented: $viewModel.presentImagePicker) {
            ImageSelectionView(isPresented: $viewModel.presentImagePicker,
                               sourceType: viewModel.sourceType,
                               destinationView: destinationView)
        }
    }
}

struct ImageSourceSelectionButton_Previews: PreviewProvider {
    static var previews: some View {
        ImageSourceSelectionButton(
            displayView: { UserProfileImageView(profileImageKey: "emptyUserPic") },
            destinationView: { selectedImage in Image(uiImage: selectedImage) }
        )
    }
}
