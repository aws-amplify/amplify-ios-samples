//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Combine
import Foundation
import Kingfisher

class PhotoSharingImageProvider: ImageDataProvider {

    public var cacheKey: String
    private var storageService: StorageService
    private var subscribers = Set<AnyCancellable>()

    init(key: String,
         manager: ServiceManager = AppServiceManager.shared) {
        self.cacheKey = key
        self.storageService = manager.storageService
    }

    public func data(handler: @escaping (Result<Data, Error>) -> Void) {
        let ops = self.storageService.downloadImage(key: cacheKey)
        ops.resultPublisher.sink {
            if case let .failure(storageError) = $0 {
                handler(.failure(storageError))
            }
        }
        receiveValue: { data in
            handler(.success(data))
        }
        .store(in: &subscribers)
    }
}
