//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: MIT-0
//

import Amplify
import Foundation
import Combine

protocol StorageService {
    func uploadImage(key: String, _ data: Data) -> StorageUploadDataTask
    func downloadImage(key: String) -> StorageDownloadDataTask
    func removeImage(key: String) async throws -> String
}
