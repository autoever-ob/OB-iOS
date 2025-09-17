//
//  EmailStepView.swift
//  campick
//
//  Created by Admin on 9/17/25.
//

import SwiftUI

struct EmailStepView: View {
    @Binding var userType: UserType?
    @Binding var email: String
    @Binding var showCodeField: Bool
    @Binding var code: String
    var onNext: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("사용자 유형").foregroundStyle(.white.opacity(0.9)).bold()
            HStack(spacing: 10) {
                PrimaryActionButton(title: "일반 사용자", titleFont: .system(size: 16, weight: .semibold), systemImage: "person", height: 28) { userType = .normal }
                    .opacity(userType == .normal ? 1.0 : (userType == nil ? 0.6 : 0.8))
                PrimaryActionButton(title: "딜러", titleFont: .system(size: 16, weight: .semibold), systemImage: "car.2", height: 28) { userType = .dealer }
                    .opacity(userType == .dealer ? 1.0 : (userType == nil ? 0.6 : 0.8))
            }

            if userType != nil {
                Text("이메일").foregroundStyle(.white.opacity(0.9)).bold()
                HStack(spacing: 8) {
                    OutlinedInputField(text: $email, placeholder: "이메일을 입력하세요", systemImage: "envelope", isSecure: false)
                    PrimaryActionButton(title: "인증하기", titleFont: .system(size: 16, weight: .semibold), height: 22, isDisabled: email.isEmpty) {
                        showCodeField = true
                    }
                    .frame(width: 100)
                }
                if showCodeField {
                    Text("이메일 인증번호").foregroundStyle(.white.opacity(0.9)).bold()
                    OutlinedInputField(text: $code, placeholder: "인증번호", systemImage: "number", isSecure: false, keyboardType: .numberPad)
                        .onChange(of: code) { _, newValue in
                            let digits = newValue.filter { $0.isNumber }
                            if digits != newValue { code = digits }
                        }
                    if !code.isEmpty {
                        PrimaryActionButton(title: "다음", titleFont: .system(size: 18, weight: .semibold), height: 32) { onNext() }
                    }
                }
            }
        }
    }
}

