//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: MIT-0
//

import SwiftUI
import Amplify
import Combine
import Kingfisher

extension ConfirmProfileImageView {

    class ViewModel: ObservableObject {

        @Published private(set) var selectedImage: UIImage?
        @Published private(set) var progress: Progress?
        @Published private(set) var hasError: Bool = false
        @Published private(set) var photoSharingError: AmplifyError?

        private var subscribers = Set<AnyCancellable>()

        var dataStoreService: DataStoreService
        var storageService: StorageService

        init(selectedImage: UIImage,
             manager: ServiceManager = AppServiceManager.shared) {
            self.selectedImage = selectedImage
            self.dataStoreService = manager.dataStoreService
            self.storageService = manager.storageService
        }

        var viewDismissalPublisher = PassthroughSubject<Bool, Never>()
        private var shouldDismissView = false {
            didSet {
                viewDismissalPublisher.send(shouldDismissView)
            }
        }

        func updateProfileImage() async {
            guard var user = dataStoreService.user else { return }
            guard let pngData = selectedImage?.pngFlattened(isOpaque: true) else {
                return
            }

            user.profilePic = "\(user.username)ProfileImage"

            do {
                let storageTask = try await storageService.uploadImage(key: user.profilePic, pngData)
                storageTask.inProcessPublisher.sink { progress in
                    self.progress = progress
                    print(progress as Progress)
                }
                .store(in: &subscribers)

                storageTask.resultPublisher.sink {
                    if case let .failure(storageError) = $0 {
                        self.photoSharingError = storageError
                        self.hasError = true
                        Amplify.log.error(
                            "Error uploading selected image - \(storageError.localizedDescription)"
                        )
                        return
                    }
                    // This is to remove the old image from local cache. The reason is that the new image is
                    // using the same image key, `KFImage` displays the old image even new image is uploaded to S3
                    ImageCache.default.removeImage(forKey: user.profilePic)
                    self.dataStoreService.saveUser(user) {
                        switch $0 {
                        case .success:
                            self.progress = nil
                            self.shouldDismissView = true
                        case .failure(let error):
                            self.photoSharingError = error
                            self.hasError = true
                        }
                    }
                }
            receiveValue: { _ in }
                    .store(in: &subscribers)
            } catch {
                Amplify.log.error(
                    "Error uploading selected image - \(error.localizedDescription)"
                )
            }
        }
    }
}
