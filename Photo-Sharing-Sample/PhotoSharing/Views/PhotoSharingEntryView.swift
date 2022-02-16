//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: MIT-0
//

import SwiftUI

struct PhotoSharingEntryView: View {

    @EnvironmentObject var authService: AuthService

    var body: some View {
        VStack {
            if authService.isSignedIn {
                UserProfileView()
            } else {
                OnBoardingView()
            }
        }
    }
}

struct PhotoSharingEntryView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoSharingEntryView()
            .environmentObject(AuthService())
    }
}
