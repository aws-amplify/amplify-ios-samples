//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: MIT-0
//

import SwiftUI

extension NavigationLink where Label == EmptyView {
    init<T: Hashable>(destination: Destination, when selection: Binding<T?>, equals tag: T) {
        self.init(destination: destination,
                  tag: tag,
                  selection: selection,
                  label: EmptyView.init)
    }
}
