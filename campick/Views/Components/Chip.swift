//
//  Chip.swift
//  campick
//
//  Created by Admin on 9/16/25.
//

import SwiftUI

struct Chip: View {
    let text: String
    var systemImage: String? = nil
    var foreground: Color = .white
    var background: Color = .accentColor
    var horizontalPadding: CGFloat = 8
    var verticalPadding: CGFloat = 4
    var font: Font = .caption.bold()
    var cornerStyle: CornerStyle = .capsule
    var action: (() -> Void)? = nil

    enum CornerStyle: Equatable {
        case capsule
        case rounded(CGFloat)
    }

    init(text: String,
         systemImage: String? = nil,
         foreground: Color = .white,
         background: Color = .accentColor,
         horizontalPadding: CGFloat = 8,
         verticalPadding: CGFloat = 4,
         font: Font = .caption.bold(),
         cornerStyle: CornerStyle = .capsule,
         action: (() -> Void)? = nil) {
        self.text = text
        self.systemImage = systemImage
        self.foreground = foreground
        self.background = background
        self.horizontalPadding = horizontalPadding
        self.verticalPadding = verticalPadding
        self.font = font
        self.cornerStyle = cornerStyle
        self.action = action
    }

    // Convenience initializer to match existing usage in FindVehicleView
    init(title: String, isSelected: Bool, action: @escaping () -> Void) {
        self.text = title
        self.systemImage = nil
        self.foreground = isSelected ? .white : .white.opacity(0.85)
        self.background = isSelected ? AppColors.brandOrange : Color.white.opacity(0.12)
        self.horizontalPadding = 8
        self.verticalPadding = 6
        self.font = .caption.bold()
        self.cornerStyle = .capsule
        self.action = action
    }

    init(title: String, systemImage: String?, isSelected: Bool, action: @escaping () -> Void) {
        self.text = title
        self.systemImage = systemImage
        self.foreground = isSelected ? .white : .white.opacity(0.85)
        self.background = isSelected ? AppColors.brandOrange : Color.white.opacity(0.12)
        self.horizontalPadding = 12
        self.verticalPadding = 8
        self.font = .system(size: 12)
        self.cornerStyle = .capsule
        self.action = action
    }

    @ViewBuilder
    var body: some View {
        let content = HStack(spacing: 4) {
            if let systemImage {
                Image(systemName: systemImage)
            }
            Text(text)
        }
        .font(font)
        .foregroundStyle(foreground)
        .padding(.horizontal, horizontalPadding)
        .padding(.vertical, verticalPadding)
        .background(background)
        .clipShape({
            switch cornerStyle {
            case .capsule:
                return AnyShape(Capsule())
            case .rounded(let r):
                return AnyShape(RoundedRectangle(cornerRadius: r, style: .continuous))
            }
        }())

        if let action {
            Button(action: action) { content }
                .buttonStyle(.plain)
        } else {
            content
        }
    }
}

private struct AnyShape: Shape {
    private let pathBuilder: (CGRect) -> Path
    init<S: Shape>(_ shape: S) { self.pathBuilder = { rect in shape.path(in: rect) } }
    func path(in rect: CGRect) -> Path { pathBuilder(rect) }
}
