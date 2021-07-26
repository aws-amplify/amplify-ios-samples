//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: MIT-0
//

import SwiftUI
import Combine
import Amplify

struct PostsListingView: View {

    @StateObject var viewModel: UserProfileView.ViewModel
    @State private var pageNumber = 1

    var body: some View {
        VStack {
            LazyVStack {
                ForEach(viewModel.loadedPosts.indices, id: \.self) { index in
                    PostView(post: viewModel.loadedPosts[index])
                }
            }
            .id(UUID())
            if viewModel.numberOfMyPosts == viewModel.loadedPosts.count {
                Text("No More Posts")
                    .padding()
            } else {
                Text("Load More Posts")
                    .padding(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(lineWidth: 2))
                    .onTapGesture {
                        viewModel.fetchMyPosts(page: pageNumber)
                        pageNumber += 1
                    }
            }
        }
    }
}

struct PostsListingView_Previews: PreviewProvider {
    static var previews: some View {
        PostsListingView(viewModel: UserProfileView.ViewModel())
    }
}
