//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: MIT-0
//

import SwiftUI

struct CreatePostButton: View {
    var body: some View {
        ImageSourceSelectionButton(
            displayView: {
                Image(systemName: "plus.app")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
            },
            destinationView: { selectedImage in
                PostEditorView(image: selectedImage)
            }
        )
    }
}

struct CreatePostButton_Previews: PreviewProvider {
    static var previews: some View {
        CreatePostButton()
    }
}
