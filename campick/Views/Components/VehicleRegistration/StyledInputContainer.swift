//
//  StyledInputContainer.swift
//  campick
//
//  Created by 김호집 on 9/17/25.
//

import SwiftUI

struct StyledInputContainer<Content: View>: View {
    let hasError: Bool
    let content: () -> Content

    init(hasError: Bool = false, @ViewBuilder content: @escaping () -> Content) {
        self.hasError = hasError
        self.content = content
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(AppColors.brandBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(hasError ? Color.red : AppColors.primaryText.opacity(0.2), lineWidth: 1)
                )

            content()
        }
        .frame(height: 48)
    }
}