//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: MIT-0
//

import Combine
import Amplify

extension UserProfileBarView {

    class ViewModel: ObservableObject {
        var authService: AuthService?
        var errorTopic: PassthroughSubject<AmplifyError, Never>
        var authUser: AuthUser?

        init(manager: ServiceManager = AppServiceManager.shared) {
            self.authService = manager.authService
            self.authUser = manager.authService.authUser
            self.errorTopic = manager.errorTopic
        }

        func signOut() {
            authService?.signOut {
                switch $0 {
                case .success:
                    return
                case .failure(let error):
                    self.errorTopic.send(error)
                }
            }
        }
    }
}
