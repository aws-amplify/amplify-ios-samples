//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: MIT-0
//

import SwiftUI
import Amplify
import Combine

extension PostEditorView {

    class ViewModel: ObservableObject {
        @Published var selectedImage: UIImage?
        @Published var progress: Progress?
        @Published var hasError: Bool = false
        @Published var photoSharingError: AmplifyError?

        private var subscribers = Set<AnyCancellable>()

        var dataStoreService: DataStoreService
        var storageService: StorageService

        init(image: UIImage,
             manager: ServiceManager = AppServiceManager.shared) {
            self.selectedImage = image
            self.dataStoreService = manager.dataStoreService
            self.storageService = manager.storageService
        }

        var viewDismissalPublisher = PassthroughSubject<Bool, Never>()
        private var shouldDismissView = false {
            didSet {
                viewDismissalPublisher.send(shouldDismissView)
            }
        }

        func createNewPost(postBody: String) {
            guard let user = dataStoreService.user else { return }

            var newPost = Post(postBody: postBody,
                               pictureKey: "",
                               createdAt: .now(),
                               postedBy: user)
            let pictureKey = "\(user.username)Image\(newPost.id)"
            newPost.pictureKey = pictureKey

            guard let pngData = selectedImage?.pngFlattened(isOpaque: true) else {
                return
            }

            let storageOperation = self.storageService.uploadImage(key: "\(newPost.pictureKey)",
                                                                   pngData)
            storageOperation.progressPublisher.sink { progress in
                DispatchQueue.main.async {
                    self.progress = progress
                }
                print(progress as Progress)
            }
            .store(in: &self.subscribers)

            storageOperation.resultPublisher.sink {
                if case let .failure(storageError) = $0 {
                    DispatchQueue.main.async {
                        self.photoSharingError = storageError
                        self.hasError = true
                    }
                    Amplify.log.error(
                        "Error uploading selected image - \(storageError.localizedDescription)"
                    )
                    return
                }
                self.dataStoreService.savePost(newPost) {
                    switch $0 {
                    case .success:
                        DispatchQueue.main.async {
                            self.progress = nil
                            self.shouldDismissView = true
                        }
                    case .failure(let dataStoreError):
                        DispatchQueue.main.async {
                            self.photoSharingError = dataStoreError
                            self.hasError = true
                        }
                    }
                }
            }
            receiveValue: { _ in }
            .store(in: &self.subscribers)
        }
    }

    enum CurrentPage {
        case imagePicker
        case postEditorView
    }
}
