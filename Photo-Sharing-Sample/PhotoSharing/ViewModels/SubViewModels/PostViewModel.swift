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
            Source.provider(PhotoSharingImageProvider(key: post.pictureKey))
        }

        /// This function performs `Post` model deletion with `Amplily.DataStore` first and then image removal
        /// with `Amplify.Storage`. The reason of such order is lack of being able to perform two operations
        /// as a transaction, the failure of removing image is acceptable as long as `Post` model is deleted.
        func deletePost() async {

            do {
                // firstly, delete the Post instance from DynamoDB and local database
                try await dataStoreService.deletePost(post)
                // secondly, remove the associated image from S3
                _ = try await storageService.removeImage(key: post.pictureKey)
            } catch let error as StorageError {
                Amplify.log.error(
                """
                \(#function) Error removing image - \(error.localizedDescription)
                """)
            } catch let error as DataStoreError {
                let postDeletionError = PhotoSharingError.model(
                    "Failed to delete the Post",
                    "Please try again",
                    error
                )
                self.errorTopic.send(postDeletionError)
                Amplify.log.error("\(#function) Error deleting post - \(error.localizedDescription)")
            } catch {

            }
        }
    }
}
