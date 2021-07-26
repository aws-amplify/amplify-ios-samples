//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import SwiftUI
import Amplify

struct UserProfileView: View {

    @StateObject var viewModel = ViewModel()
    @State private var nameOnTopLeftCorner = false

    var body: some View {
        VStack {
            UserProfileBarView(nameOnTopLeftCorner: $nameOnTopLeftCorner)
            ScrollView(.vertical) {
                ScrollViewReader { scrollView in
                    LazyVStack {
                        ImageSourceSelectionButton(
                            displayView: {
                                UserProfileImageView(
                                    profileImageKey: viewModel.user?.profilePic ?? "emptyUserPic"
                                )
                                .asCircle(diameter: 100, lineWidth: 2)
                                .padding(.top, 8)
                            }, destinationView: { selectedImage in
                                ConfirmProfileImageView(selectedImage: selectedImage)
                            }
                        )
                        Text(viewModel.user?.username ?? "")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .onAppear {
                                withAnimation(Animation.default) {
                                    nameOnTopLeftCorner = false
                                }
                            }
                            .onDisappear {
                                withAnimation(Animation.default) {
                                    nameOnTopLeftCorner = true
                                }
                            }
                        VStack {
                            Text("\(viewModel.numberOfMyPosts)")
                            Text("posts")
                            // The loader View is showed when no posts is queried into memory
                            // and postSynced event not received yet
                            if viewModel.loadedPosts.isEmpty && !viewModel.isPostSynced {
                                Loader(description: "Loading Your Posts")
                            }
                        }.onTapGesture {
                            withAnimation {
                                scrollView.scrollTo(0, anchor: .top)
                            }
                        }
                    }
                    PostsListingView(viewModel: viewModel)
                }
            }
        }
        .alert(isPresented: $viewModel.hasError) {
            Alert(title: Text("An error occured"),
                  message: Text(viewModel.photoSharingError?.recoverySuggestion ?? ""),
                  dismissButton: .default(Text("Got it!")))
        }
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView()
    }
}
