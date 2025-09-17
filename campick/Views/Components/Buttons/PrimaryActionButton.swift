//
//  PrimaryActionButton.swift
//  campick
//
//  Created by Admin on 9/17/25.
//

import SwiftUI

struct PrimaryActionButton: View {
    var title: String
    var titleFont: Font = .headline
    var isDisabled: Bool = false
    var systemImage: String? = nil
    var width: CGFloat? = nil
    var height: CGFloat? = 48
    var cornerRadius: CGFloat = 10
    var fill: Color = AppColors.brandOrange
    var foreground: Color = .white
    

    // MARK: Action
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let systemImage {
                    Image(systemName: systemImage)
                }
                Text(title)
                    .font(titleFont)
            }
            .frame(width: width, height: height, alignment: .center)
            .frame(maxWidth: width == nil ? .infinity : nil)
        }
        .buttonStyle(
            BrandFilledButtonStyle(
                cornerRadius: cornerRadius,
                fill: fill,
                foreground: foreground
            )
        )
        .disabled(isDisabled)
    }
}

#Preview("PrimaryActionButton Variants") {
    VStack(spacing: 16) {
        PrimaryActionButton(title: "로그인") { }
        PrimaryActionButton(title: "다음", systemImage: "arrow.right", height: 52) { }
        PrimaryActionButton(title: "확인", isDisabled: true, width: 200, height: 44) { }
        PrimaryActionButton(title: "커스텀", width: 220, cornerRadius: 14, fill: .blue, foreground: .white) { }
    }
    .padding()
    .background(AppColors.background)
}
