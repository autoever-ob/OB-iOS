//
//  PasswordStepView.swift
//  campick
//
//  Created by Admin on 9/17/25.
//

import SwiftUI

struct PasswordStepView: View {
    @Binding var password: String
    @Binding var confirm: String
    @Binding var errorMessage: String?
    var onNext: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("비밀번호").foregroundStyle(.white.opacity(0.9)).bold()
            NoPasteSecureField(text: $password, placeholder: "비밀번호 (8자 이상)")
            if !password.isEmpty {
                Text("비밀번호 확인").foregroundStyle(.white.opacity(0.9)).bold()
                NoPasteSecureField(text: $confirm, placeholder: "비밀번호 확인")
            }
            if let errorMessage {
                Text(errorMessage).foregroundStyle(.red).font(.caption)
            }
            if !confirm.isEmpty {
                PrimaryActionButton(title: "다음", titleFont: .system(size: 18, weight: .semibold), height: 32) {
                    if password.count >= 8 && confirm == password {
                        errorMessage = nil
                        onNext()
                    } else {
                        errorMessage = "비밀번호가 일치하지 않거나 8자 미만입니다."
                    }
                }
            }
        }
    }
}
