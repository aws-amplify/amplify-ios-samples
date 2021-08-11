//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: MIT-0
//

import SwiftUI
import Combine
import Amplify
import Kingfisher

protocol ServiceManager {
    var authService: AuthService { get }
    var dataStoreService: DataStoreService { get }
    var storageService: StorageService { get }
    var errorTopic: PassthroughSubject<AmplifyError, Never> { get }
    func configure()
}

class AppServiceManager: ServiceManager {

    private init() {}

    static let shared = AppServiceManager()

    let authService: AuthService = AmplifyAuthService()
    let dataStoreService: DataStoreService = AmplifyDataStoreService()
    let storageService: StorageService = AmplifyStorageService()
    let errorTopic = PassthroughSubject<AmplifyError, Never>()

    func configure() {
        authService.configure()
        dataStoreService.configure(authService.sessionStatePublisher)
    }
}
