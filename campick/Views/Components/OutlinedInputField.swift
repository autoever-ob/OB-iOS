//
//  OutlinedInputField.swift
//  campick
//
//  Created by Admin on 9/16/25.
//

import Foundation
import SwiftUI

struct OutlinedInputField: View {
    @Binding var text: String
    let placeholder: String
    let systemImage: String?
    var isSecure: Bool = false
    @State private var isRevealed: Bool = false
    var keyboardType: UIKeyboardType? = nil
    
    init(text: Binding<String>,
             placeholder: String,
             systemImage: String? = nil,
             isSecure: Bool = false,
             keyboardType: UIKeyboardType? = nil) {
            self._text = text
            self.placeholder = placeholder
            self.systemImage = systemImage
            self.isSecure = isSecure
            self.keyboardType = keyboardType
        }

    
    var body: some View {
        HStack(spacing: 8) {
            ZStack(alignment: .leading) {
                if text.isEmpty {
                    Text(placeholder)
                        .foregroundColor(.white.opacity(0.6))
                        .padding(.leading, 4)
                }
                
                if isSecure {
                    TextField("", text: $text)
                        .textContentType(.password)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                        .foregroundStyle(.white)
                        .tint(AppColors.brandOrange)
                        .font(.body)
                        .frame(height: 22)
                        .opacity(isRevealed ? 1 : 0)
                        .allowsHitTesting(isRevealed)
                    
                    SecureField("", text: $text)
                        .textContentType(.password)
                        .foregroundStyle(.white)
                        .tint(AppColors.brandOrange)
                        .font(.body)
                        .frame(height: 22)
                        .opacity(isRevealed ? 0 : 1)
                        .allowsHitTesting(!isRevealed)
                } else {
                    TextField("", text: $text)
                        .keyboardType(keyboardType ?? .emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                        .foregroundStyle(.white)
                        .tint(AppColors.brandOrange)
                }
            }
            
            if isSecure {
                Button(action: { isRevealed.toggle() }) {
                    Image(systemName: isRevealed ? "eye.slash" : "eye")
                        .foregroundColor(.white.opacity(0.8))
                        .frame(width: 24)
                }
            }
            
            if let systemImage {
                Image(systemName: systemImage)
                    .foregroundColor(.white.opacity(0.8))
                    .frame(width: 24, alignment: .leading)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
    }
}

#Preview("OutlinedInputField – All Variants") {
    @Previewable @State var email: String = ""
    @Previewable @State var password: String = ""

    ZStack {
        AppColors.brandBackground.ignoresSafeArea()
        VStack(spacing: 16) {
            // Email field with icon
            OutlinedInputField(
                text: $email,
                placeholder: "이메일을 입력하세요",
                systemImage: "envelope",
                isSecure: false
            )

            // Password secure field
            OutlinedInputField(
                text: $password,
                placeholder: "비밀번호를 입력하세요",
                systemImage: nil,
                isSecure: true
            )
        }
        .padding()
    }
}
