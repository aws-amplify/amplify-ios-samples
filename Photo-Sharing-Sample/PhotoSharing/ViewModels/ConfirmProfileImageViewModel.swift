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

            let storageTask = storageService.uploadImage(key: user.profilePic, pngData)
            Task {
                for await storageProgress in await storageTask.progress {
                    self.progress = storageProgress
                    print(storageProgress as Progress)
                }
            }

            do {
                _ = try await storageTask.value
                // This is to remove the old image from local cache. The reason is that the new image is
                // using the same image key, `KFImage` displays the old image even new image is uploaded to S3
                ImageCache.default.removeImage(forKey: user.profilePic)
                _ = try await dataStoreService.saveUser(user)
                progress = nil
                shouldDismissView = true

            } catch let error as AmplifyError {
                self.photoSharingError = error
                self.hasError = true
                Amplify.log.error(
                    "Error uploading selected image - \(error.localizedDescription)"
                )
            } catch {
                Amplify.log.error(
                    "Error uploading selected image - \(error.localizedDescription)"
                )
            }
        }
    }
}
