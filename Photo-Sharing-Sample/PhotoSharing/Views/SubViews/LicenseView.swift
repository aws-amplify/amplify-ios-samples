//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: MIT-0
//

import SwiftUI

struct LicenseView: View {
    let viewModel = LicenseViewModel()

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            Color(.systemOrange).ignoresSafeArea()

            VStack {
                Button("Dismiss") {
                    presentationMode.wrappedValue.dismiss()
                }
                .padding()

                Text("Photo Sharing Sample")
                    .foregroundColor(.white)
                    .font(.system(size: 36))
                    .fontWeight(.semibold)

                ScrollView {
                    Text(viewModel.license)
                        .foregroundColor(.white)
                        .padding()
                }

                Spacer()
            }
        }
    }
}

struct LicenseView_Previews: PreviewProvider {
    static var previews: some View {
        LicenseView()
    }
}
