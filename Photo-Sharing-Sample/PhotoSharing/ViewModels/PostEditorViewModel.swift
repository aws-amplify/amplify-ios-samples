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

    @MainActor
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

        func createNewPost(postBody: String) async {
            guard let user = dataStoreService.user else { return }

            var newPost = Post(postBody: postBody,
                               pictureKey: "",
                               createdAt: .now(),
                               postedBy: user)
            let pictureKey = "\(user.username)Image\(newPost.id)"
            newPost.pictureKey = pictureKey
            let newPostImmutable = newPost
            guard let pngData = selectedImage?.pngFlattened(isOpaque: true) else {
                return
            }

            let storageTask = storageService.uploadImage(
                key: "\(newPostImmutable.pictureKey)",
                pngData)
            Task {
                for await storageProgress in await storageTask.progress {
                    self.progress = storageProgress
                    print(storageProgress as Progress)
                }
            }

            do {
                _ = try await storageTask.value
                _ = try await dataStoreService.savePost(newPostImmutable)
                progress = nil
                shouldDismissView = true

            } catch let storageError as AmplifyError {
                self.photoSharingError = storageError
                self.hasError = true
                Amplify.log.error(
                    "Error uploading selected image - \(storageError.localizedDescription)"
                )
            } catch {
                Amplify.log.error(
                    "Error uploading selected image - \(error.localizedDescription)"
                )
            }


        }

    }

    enum CurrentPage {
        case imagePicker
        case postEditorView
    }
}
