//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import Combine

extension PhotoSharingApp {

    class ViewModel: ObservableObject {
        var sessionState: SessionState {
            authService.sessionState
        }

        private var authService: AuthService

        private var subscribers = Set<AnyCancellable>()

        init(manager: ServiceManager = AppServiceManager.shared) {
            self.authService = manager.authService
            observeState()
        }

        private func observeState() {
            authService.sessionStatePublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    self?.objectWillChange.send()
                }
                .store(in: &subscribers)
        }
    }
}
