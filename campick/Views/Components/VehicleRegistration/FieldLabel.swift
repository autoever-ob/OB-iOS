//
//  FieldLabel.swift
//  campick
//
//  Created by 김호집 on 9/17/25.
//

import SwiftUI

struct FieldLabel: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.system(size: 12, weight: .medium))
            .foregroundColor(.white.opacity(0.8))
    }
}