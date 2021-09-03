//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: MIT-0
//

import SwiftUI
import Amplify

struct ConfirmProfileImageView: View {

    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel: ViewModel
    @State private var updateButtonDisabled = false

    init(selectedImage: UIImage) {
        self._viewModel = StateObject(wrappedValue: ViewModel(selectedImage: selectedImage))
    }

    var body: some View {
        VStack {
            HStack {
                Text("Cancel")
                    .foregroundColor(updateButtonDisabled ? .gray : .primary)
                    .disabled(updateButtonDisabled)
                    .onTapGesture {
                        withAnimation(Animation.default) {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    .padding()
                Spacer()
                Text("Update")
                    .foregroundColor(updateButtonDisabled ? .gray : .primary)
                    .disabled(updateButtonDisabled)
                    .onTapGesture {
                        updateButtonDisabled = true
                        viewModel.updateProfileImage()
                    }
                    .padding()
            }
            if let progress = viewModel.progress {
                ProgressView(value: CGFloat(progress.completedUnitCount),
                             total: CGFloat(progress.totalUnitCount))
            }
            Spacer()
            if let selectedImage = viewModel.selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .asCircle(diameter: 250, lineWidth: 3)
            }
            Spacer()
        }
        .onReceive(viewModel.viewDismissalPublisher) { shouldDismiss in
            if shouldDismiss {
                self.presentationMode.wrappedValue.dismiss()
            }
        }
        .transition(.asymmetric(insertion: .move(edge: .trailing),
                                removal: .move(edge: .leading)))
    }
}

struct ConfirmProfileImageView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmProfileImageView(
            selectedImage: UIImage(systemName: "person.crop.circle.fill")!
        )
    }
}
