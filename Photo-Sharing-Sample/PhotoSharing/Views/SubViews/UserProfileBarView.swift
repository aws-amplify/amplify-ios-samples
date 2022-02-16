//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: MIT-0
//

import SwiftUI
import Combine
import Amplify

struct UserProfileBarView: View {

    @StateObject var viewModel = ViewModel()
    @Binding var nameOnTopLeftCorner: Bool
    @State private var showingSheet = false

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
                    showingSheet = true
                } label: {
                    Text("About")
                        .fontWeight(.bold)
                        .padding()
                }

                Button {
                    viewModel.signOut()
                } label: {
                    Text("Sign Out")
                        .fontWeight(.bold)
                        .padding()
                }
            } label: {
                Image(systemName: "line.horizontal.3")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
                    .foregroundColor(.primary)
            }
            .sheet(isPresented: $showingSheet) {
                LicenseView()
            }
            .padding(.horizontal)
        }
        .frame(height: 40)
    }
}

struct UserProfileBarView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileBarView(nameOnTopLeftCorner: Binding.constant(true))
    }
}
