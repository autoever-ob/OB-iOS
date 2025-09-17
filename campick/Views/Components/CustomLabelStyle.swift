//
//  CompactLabelStyle.swift
//  campick
//
//  Created by Admin on 9/16/25.
//

import SwiftUI

struct CustomLabelStyle: LabelStyle {
    var spacing: CGFloat = 50
    var iconScale: Image.Scale = .small

    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: spacing) {
            configuration.icon
                .imageScale(iconScale)
            configuration.title
        }
    }
}

