//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: MIT-0
//

import SwiftUI
import Amplify

struct OnBoardingView: View {

    @StateObject var viewModel = ViewModel()

    var body: some View {
        ZStack {
            Color(.systemOrange).ignoresSafeArea()
            VStack {
                Spacer()
                Text("Photo Sharing Sample")
                    .foregroundColor(.white)
                    .font(.system(size: 36))
                    .fontWeight(.semibold)
                    .padding(.top, 20)
                Spacer()
                Button(action: viewModel.signIn) {
                    Text("SIGN IN / SIGN UP")
                        .fontWeight(.bold)
                        .padding(.horizontal, 60)
                        .padding(.vertical, 16)
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(buttonCornerRadius)
                        .overlay(
                            RoundedRectangle(cornerRadius: buttonCornerRadius)
                                .stroke(Color.black, lineWidth: 2))
                        .padding(.bottom, 20)
                }
            }
        }
        .alert(isPresented: $viewModel.hasError) {
            Alert(title: Text("An error occured"),
                  message: Text(viewModel.photoSharingError?.recoverySuggestion ?? ""),
                  dismissButton: .default(Text("Got it!")))
        }
    }

    // MARK: Drawing constants

    private let buttonCornerRadius: CGFloat = 8
}

struct OnBoardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingView()
    }
}
