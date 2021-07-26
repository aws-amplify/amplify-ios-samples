//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: MIT-0
//

import SwiftUI

extension View {
    func asCircle(diameter: CGFloat, lineWidth: CGFloat) -> some View {
        modifier(CircleProfileModifier(diameter: diameter,
                                       lineWidth: lineWidth))
    }
}

struct CircleProfileModifier: ViewModifier {

    var diameter: CGFloat
    var lineWidth: CGFloat

    func body(content: Content) -> some View {
        content
            .frame(width: diameter, height: diameter)
            .clipShape(Circle())
            .overlay(Circle().stroke(lineWidth: lineWidth))
    }
}
