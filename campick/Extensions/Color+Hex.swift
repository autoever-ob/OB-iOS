//
//  Color+Hex.swift
//  campick
//
//  Created by Admin on 9/15/25.
//

import SwiftUI

public extension Color {
    /// 헥사코드(예: "0B211A", "#0B211A")로 SwiftUI Color를 생성
    init(hex: String, opacity: Double = 1.0) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)

        let r, g, b: UInt64
        switch hex.count {
        case 6: // RRGGBB
            (r, g, b) = ((int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (0, 0, 0)
        }

        self.init(.sRGB,
                  red: Double(r) / 255.0,
                  green: Double(g) / 255.0,
                  blue:  Double(b) / 255.0,
                  opacity: opacity)
    }
}
