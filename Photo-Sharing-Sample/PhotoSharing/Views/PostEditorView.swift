//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: MIT-0
//

import SwiftUI

struct PostEditorView: View {

    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: ViewModel
    @State private var postBody = ""
    @State private var shareButtonDisabled = false
    @State private var errorMessage = false

    init(image: UIImage) {
        self._viewModel = StateObject(wrappedValue: ViewModel(image: image))
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Cancel")
                    .foregroundColor(shareButtonDisabled ? .gray : .primary)
                    .disabled(shareButtonDisabled)
                    .onTapGesture {
                        presentationMode.wrappedValue.dismiss()
                    }
                Spacer()
                Text("New Post").bold()
                Spacer()
                Text("Share")
                    .foregroundColor(shareButtonDisabled ? .gray : .primary)
                    .disabled(shareButtonDisabled)
                    .onTapGesture {
                        guard !postBody.isEmpty else {
                            self.errorMessage = true
                            DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                                self.errorMessage = false
                            }
                            return
                        }
                        shareButtonDisabled = true
                        viewModel.createNewPost(postBody: postBody)
                    }
            }
            if let progress = viewModel.progress {
                ProgressView(value: CGFloat(progress.completedUnitCount),
                             total: CGFloat(progress.totalUnitCount))
            }
            if let image = viewModel.selectedImage {
                HStack {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 200, height: 200)
                        .clipShape(Rectangle())
                    Spacer()
                }
            }
            Divider()
            TextField("Say something about this image",
                      text: self.$postBody)
                .disabled(shareButtonDisabled)
            if errorMessage {
                Text("Please say something about this image before sharing")
                    .foregroundColor(.red)
            }
            Spacer()
        }
        .padding(.horizontal)
        .transition(.asymmetric(insertion: .move(edge: .trailing),
                                removal: .move(edge: .leading)))
        .onReceive(viewModel.viewDismissalPublisher) { shouldDismiss in
            if shouldDismiss {
                self.presentationMode.wrappedValue.dismiss()
            }
        }
        .onTapGesture {
            UIApplication.hideKeyboard()
        }
        .alert(isPresented: $viewModel.hasError) {
            Alert(title: Text("An error occured"),
                  message: Text(viewModel.photoSharingError?.recoverySuggestion ?? ""),
                  dismissButton: .default(Text("Got it!")))
        }
    }
}

struct PostEditorView_Previews: PreviewProvider {
    static var previews: some View {
        PostEditorView(image: UIImage(systemName: "photo.fill")!)
    }
}
