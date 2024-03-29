//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: MIT-0
//

import SwiftUI
import Kingfisher

struct UserProfileImageView: View {

    @StateObject private var viewModel: ViewModel

    private static let emptyUserPicKey = "emptyUserPic"

    init(profileImageKey: String?) {
        _viewModel = StateObject(wrappedValue: ViewModel(profileImageKey: profileImageKey ??
                                                         UserProfileImageView.emptyUserPicKey))
    }

    var body: some View {
        VStack {
            if viewModel.profileImageKey == UserProfileImageView.emptyUserPicKey {
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .scaledToFill()
                    .font(Font.title.weight(.ultraLight))
                    .foregroundColor(.white)
                    .background(Color(.lightGray))
            } else {
                KFImage(source: viewModel.profileImageSource())
                    .loadImmediately()
                    .resizable()
                    .scaledToFill()
            }
        }
    }
}

struct UserProfileImageView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileImageView(profileImageKey: "emptyUserPic")
    }
}
