//
//  ErrorText.swift
//  campick
//
//  Created by 김호집 on 9/17/25.
//

import SwiftUI

struct ErrorText: View {
    let message: String?

    var body: some View {
        if let message = message {
            Text(message)
                .font(.system(size: 10))
                .foregroundColor(.red)
        }
    }
}