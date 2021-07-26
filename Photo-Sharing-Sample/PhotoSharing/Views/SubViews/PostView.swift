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

struct PostView: View {

    @StateObject var viewModel: ViewModel
    @State private var showSheet = false
    @State private var imageIsLoading = true
    @State private var errorLoadingImage = false

    init(post: Post) {
        self._viewModel = StateObject(wrappedValue: ViewModel(post: post))
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                UserProfileImageView(profileImageKey: viewModel.post.postedBy.profilePic)
                    .asCircle(diameter: 36, lineWidth: 1)
                VStack(alignment: .leading) {
                    Text(viewModel.post.postedBy.username)
                        .font(.system(size: 20))
                        .bold()
                    CreatedAtSinceNowView(createdAt: viewModel.post.createdAt)
                }
                Spacer()
                Image(systemName: "ellipsis")
                    .onTapGesture {
                        self.showSheet = true
                    }
                    .actionSheet(isPresented: $showSheet) {
                        ActionSheet(title: Text("Action to this post"),
                                    message: Text("Choose from following"),
                                    buttons: [
                                        .default(Text("Delete")) {
                                            self.viewModel.deletePost()
                                        },
                                        .cancel()
                                    ]
                        )
                    }
            }
            Text(viewModel.post.postBody)
            ZStack {
                KFImage(source: viewModel.imageSource())
                    .loadImmediately()
                    .onSuccess { _ in
                        self.imageIsLoading = false
                        self.errorLoadingImage = false
                    }
                    .onFailure { _ in
                        self.errorLoadingImage = true
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                if imageIsLoading && !errorLoadingImage {
                    Loader(description: "Loading Image...")
                }
                if errorLoadingImage {
                    Text("Failed to load image")
                }
            }
        }
        .padding()
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        let user = User(username: "amplify", profilePic: "emptyUserPic")
        let post = Post(postBody: "post body", pictureKey: "PictureKey0", createdAt: .now(), postedBy: user)
        PostView(post: post)
    }
}
