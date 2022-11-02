//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: MIT-0
//

import Amplify
import Foundation

public class AmplifyStorageService: StorageService {

    func uploadImage(key: String,
                     _ data: Data) async throws -> StorageUploadDataTask {
        let options = StorageUploadDataRequest.Options(accessLevel: .protected)
        return try await Amplify.Storage.uploadData(key: key,
                                          data: data,
                                          options: options)
    }

    func downloadImage(key: String) async throws -> StorageDownloadDataTask {
        let options = StorageDownloadDataRequest.Options(accessLevel: .protected)
        return try await Amplify.Storage.downloadData(key: key, options: options)
    }

    func removeImage(key: String) async throws -> String {
        let options = StorageRemoveRequest.Options(accessLevel: .protected)
        return try await Amplify.Storage.remove(key: key,
                                      options: options)
    }
}
