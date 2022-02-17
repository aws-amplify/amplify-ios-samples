//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: MIT-0
//

import Amplify
import SwiftUI

struct AuthErrorView: View {
    let error: AuthError

    var body: some View {
        Text("\(error.errorDescription)\n\n\(error.recoverySuggestion)")
            .font(.system(size: 14, weight: .semibold))
            .foregroundColor(.red)
    }
}

struct LoadingButton: View {
    let title: String
    let isLoading: Bool
    let action: () -> Void

    var body: some View {
        ZStack {
            Button(action: action) {
                HStack {
                    Spacer()
                    Text(title)
                        .foregroundColor(isLoading ? .lightOrange : .white)
                        .padding(10)
                    Spacer()
                }
                .background(isLoading ? Color.lightOrange : Color.orange)
                .cornerRadius(5)
            }
            .disabled(isLoading)
            if isLoading {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            }
        }
    }
}

struct AuthContainerView<Content: View>: View {
    private let title: String
    private let content: Content

    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        ZStack {
            Color.lightGray.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 15) {
                Text(title)
                    .font(.system(size: 30, weight: .bold))
                    .padding(.bottom, 10)
                content
            }
            .padding()
            .background(Color.white)
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.black, lineWidth: 2)
            )
            .padding()
        }
    }
}

struct InputField: View {
    private let title: String
    @Binding private var text: String
    private let isSecure: Bool

    init(_ title: String, text: Binding<String>, isSecure: Bool = false) {
        self.title = title
        self._text = text
        self.isSecure = isSecure
    }

    var body: some View {
        createInput()
            .disableAutocorrection(true)
            .autocapitalization(.none)
            .padding(10)
            .background(Color.white)
            .border(Color.gray)
    }

    @ViewBuilder private func createInput() -> some View {
        if isSecure {
            SecureField(title, text: $text)
        } else {
            TextField(title, text: $text)
        }
    }
}
