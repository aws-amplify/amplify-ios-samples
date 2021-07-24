//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Amplify
import Foundation

public class AmplifyStorageService: StorageService {

    func uploadImage(key: String,
                     _ data: Data) -> StorageUploadDataOperation {
        let options = StorageUploadDataRequest.Options(accessLevel: .protected)
        return Amplify.Storage.uploadData(key: key,
                                          data: data,
                                          options: options)
    }

    func downloadImage(key: String) -> StorageDownloadDataOperation {
        let options = StorageDownloadDataRequest.Options(accessLevel: .protected)
        return Amplify.Storage.downloadData(key: key, options: options)
    }

    func removeImage(key: String) -> StorageRemoveOperation {
        let options = StorageRemoveRequest.Options(accessLevel: .protected)
        return Amplify.Storage.remove(key: key,
                                      options: options)
    }
}
