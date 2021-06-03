//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import SwiftUI
import Combine
import Amplify

struct UserProfileBarView: View {

    @StateObject var viewModel = ViewModel()
    @Binding var nameOnTopLeftCorner: Bool
    @State private var showSheet = false

    var body: some View {
        HStack {
            if self.nameOnTopLeftCorner {
                Text(viewModel.authUser?.username ?? "")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
            }
            Spacer()
            CreatePostButton()
            Menu {
                Button {
                    viewModel.signOut()
                } label: {
                    Text("SIGN OUT")
                        .fontWeight(.bold)
                        .padding()
                }
            } label: {
                Image(systemName: "line.horizontal.3")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
                    .foregroundColor(.black)
            }
            .padding(.horizontal)
        }.frame(height: 40)
    }
}

struct UserProfileBarView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileBarView(nameOnTopLeftCorner: Binding.constant(true))
    }
}
