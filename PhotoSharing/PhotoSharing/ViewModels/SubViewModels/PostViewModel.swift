//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import SwiftUI
import Amplify
import Combine
import Kingfisher

extension PostView {

    class ViewModel: ObservableObject {

        var post: Post
        var dataStoreService: DataStoreService
        var storageService: StorageService
        var errorTopic: PassthroughSubject<AmplifyError, Never>

        init(post: Post,
             manager: ServiceManager = AppServiceManager.shared) {
            self.post = post
            self.dataStoreService = manager.dataStoreService
            self.storageService = manager.storageService
            self.errorTopic = manager.errorTopic
        }

        private var subscribers = Set<AnyCancellable>()

        func imageSource() -> Source {
            Source.provider(PhotoSharingImageProvider(key: self.post.pictureKey))
        }

        /// This function performs `Post` model deletion with `Amplily.DataStore` first and then image removal
        /// with `Amplify.Storage`. The reason of such order is lack of being able to perform two operations
        /// as a transaction, the failure of removing image is acceptable as long as `Post` model is deleted.
        func deletePost() {
            // firstly, delete the Post instance from DynamoDB and local database
            dataStoreService.deletePost(self.post) {
                switch $0 {
                case .success:
                    // secondly, remove the associated image from S3
                    self.storageService
                        .removeImage(key: self.post.pictureKey)
                        .resultPublisher
                        .sink {
                            if case let .failure(storageError) = $0 {
                                Amplify.log.error(
                                """
                                \(#function) Error removing image - \(storageError.localizedDescription)
                                """)
                            }
                        }
                        receiveValue: { _ in }
                        .store(in: &self.subscribers)
                case .failure(let error):
                    let postDeletionError = PhotoSharingError.model(
                        "Failed to delete the Post",
                        "Please try again",
                        error
                    )
                    self.errorTopic.send(postDeletionError)
                    Amplify.log.error("\(#function) Error deleting post - \(error.localizedDescription)")
                }
            }
        }
    }
}
