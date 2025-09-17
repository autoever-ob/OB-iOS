//
//  StyledTextEditorContainer.swift
//  campick
//
//  Created by 김호집 on 9/17/25.
//

import SwiftUI

struct StyledTextEditorContainer: View {
    let hasError: Bool
    let placeholder: String
    @Binding var text: String
    let height: CGFloat

    init(
        hasError: Bool = false,
        placeholder: String,
        text: Binding<String>,
        height: CGFloat = 120
    ) {
        self.hasError = hasError
        self.placeholder = placeholder
        self._text = text
        self.height = height
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 8)
                .fill(AppColors.brandBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(hasError ? Color.red : AppColors.primaryText.opacity(0.2), lineWidth: 1)
                )

            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(.white.opacity(0.4))
                    .font(.system(size: 14))
                    .padding(.horizontal, 12)
                    .padding(.top, 12)
                    .allowsHitTesting(false)
            }

            TextEditor(text: $text)
                .foregroundColor(.white)
                .font(.system(size: 14))
                .scrollContentBackground(.hidden)
                .padding(.horizontal, 8)
                .padding(.vertical, 8)
        }
        .frame(height: height)
    }
}