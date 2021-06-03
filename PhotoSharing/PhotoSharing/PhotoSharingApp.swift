//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import SwiftUI
import Combine
import Amplify
import AmplifyPlugins

@main
struct PhotoSharingApp: App {

    @ObservedObject private var viewModel = ViewModel()

    init() {
        configureAmplify()
        AppServiceManager.shared.configure()
    }

    var body: some Scene {
        WindowGroup {
            switch viewModel.sessionState {
            case .signedIn:
                UserProfileView()
            case .signedOut:
                OnBoardingView()
            }
        }
    }
}

func configureAmplify() {

    #if DEBUG
    Amplify.Logging.logLevel = .debug
    #endif

    do {
        try Amplify.add(plugin: AWSCognitoAuthPlugin())
        try Amplify.add(plugin: AWSDataStorePlugin(modelRegistration: AmplifyModels()))
        try Amplify.add(plugin: AWSAPIPlugin())
        try Amplify.add(plugin: AWSS3StoragePlugin())
        try Amplify.configure()
        Amplify.log.info("Successfully initialized Amplify")
    } catch {
        Amplify.log.error(error: error)
        assert(true, "An error occurred configuring Amplify: \(error)")
    }
}
