//
//  BrandFilledButtonStyle.swift
//  campick
//
//  Created by Admin on 9/16/25.
//

import Foundation
import SwiftUI

struct BrandFilledButtonStyle: ButtonStyle {
    var cornerRadius: CGFloat = 10
    var fill: Color = .brandOrange
    var foreground: Color = .white

    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(foreground)
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                (isEnabled ? fill : fill.opacity(0.5))
                    .opacity(configuration.isPressed ? 0.85 : 1.0)
            )
            .cornerRadius(cornerRadius)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeOut(duration: 0.08), value: configuration.isPressed)
    }
}
