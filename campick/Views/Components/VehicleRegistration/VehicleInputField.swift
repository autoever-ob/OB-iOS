//
//  VehicleInputField.swift
//  campick
//
//  Created by 김호집 on 9/17/25.
//

import SwiftUI

struct VehicleInputField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    let keyboardType: UIKeyboardType
    let suffix: String?
    let errors: [String: String]
    let errorKey: String
    let formatNumber: ((String) -> String)?

    init(
        title: String,
        placeholder: String,
        text: Binding<String>,
        keyboardType: UIKeyboardType = .default,
        suffix: String? = nil,
        errors: [String: String] = [:],
        errorKey: String = "",
        formatNumber: ((String) -> String)? = nil
    ) {
        self.title = title
        self.placeholder = placeholder
        self._text = text
        self.keyboardType = keyboardType
        self.suffix = suffix
        self.errors = errors
        self.errorKey = errorKey
        self.formatNumber = formatNumber
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            FieldLabel(text: title)

            StyledInputContainer(hasError: errors[errorKey] != nil) {
                HStack {
                    TextField(placeholder, text: $text)
                        .foregroundColor(.white)
                        .font(.system(size: 14))
                        .keyboardType(keyboardType)
                        .onChange(of: text) { _, newValue in
                            if let formatter = formatNumber {
                                text = formatter(newValue)
                            }
                        }

                    if let suffix = suffix {
                        Text(suffix)
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.4))
                    }
                }
                .padding(.horizontal, 12)
            }

            ErrorText(message: errors[errorKey])
        }
    }
}