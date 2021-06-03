//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import SwiftUI
import Kingfisher

struct UserProfileImageView: View {

    @StateObject private var viewModel: ViewModel

    init(profileImageKey: String) {
        _viewModel = StateObject(wrappedValue: ViewModel(profileImageKey: profileImageKey))
    }

    var body: some View {
        VStack {
            if viewModel.profileImageKey == "emptyUserPic" {
                Image("emptyUserPic")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                KFImage(source: viewModel.profileImageSource())
                    .loadImmediately()
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
        }
    }
}

struct UserProfileImageView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileImageView(profileImageKey: "emptyUserPic")
    }
}
