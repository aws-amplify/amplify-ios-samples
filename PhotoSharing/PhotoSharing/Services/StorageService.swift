//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Amplify
import Foundation
import Combine

protocol StorageService {
    func uploadImage(key: String,
                     _ data: Data) -> StorageUploadDataOperation
    func downloadImage(key: String) -> StorageDownloadDataOperation
    func removeImage(key: String) -> StorageRemoveOperation
}
