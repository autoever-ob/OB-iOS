//
//  PhoneStepView.swift
//  campick
//
//  Created by Admin on 9/17/25.
//

import SwiftUI

struct PhoneStepView: View {
    @Binding var userType: UserType?
    @Binding var phone: String
    @Binding var showCodeField: Bool
    @Binding var code: String
    @Binding var codeVerified: Bool
    @Binding var showDealerField: Bool
    @Binding var dealerNumber: String
    @Binding var errorMessage: String?
    var onNext: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("휴대폰 번호").foregroundStyle(.white.opacity(0.9)).bold()
            HStack(spacing: 8) {
                OutlinedInputField(text: $phone, placeholder: "휴대폰 번호 입력", systemImage: "phone", isSecure: false, keyboardType: .numberPad)
                    .onChange(of: phone) { _, v in
                        let digits = v.filter { $0.isNumber }
                        if v != digits { phone = digits }
                    }
                PrimaryActionButton(title: "인증하기", titleFont: .system(size: 16, weight: .semibold), height: 24, isDisabled: phone.isEmpty) {
                    showCodeField = true
                }
                .frame(width: 100)
            }
            if showCodeField {
                Text("인증번호").foregroundStyle(.white.opacity(0.9)).bold()
                OutlinedInputField(text: $code, placeholder: "인증번호", systemImage: "number", isSecure: false, keyboardType: .numberPad)
                    .onChange(of: code) { _, v in
                        let digits = v.filter { $0.isNumber }
                        if v != digits { code = digits }
                    }
            }
            if let errorMessage {
                Text(errorMessage).foregroundStyle(.red).font(.caption)
            }
            if showCodeField && !code.isEmpty && !codeVerified {
                PrimaryActionButton(title: "다음", titleFont: .system(size: 18, weight: .semibold), height: 32) {
                    let hasPhone = !phone.isEmpty
                    let codeOK = (code == "0000")
                    if hasPhone && codeOK {
                        errorMessage = nil
                        codeVerified = true
                        if userType == .dealer { showDealerField = true } else { onNext() }
                    } else {
                        errorMessage = "인증번호(0000) 또는 휴대폰 번호를 확인하세요."
                    }
                }
            }
            if userType == .dealer && showDealerField {
                Text("딜러 번호").foregroundStyle(.white.opacity(0.9)).bold()
                OutlinedInputField(text: $dealerNumber, placeholder: "딜러 번호 입력", systemImage: "person.crop.circle.badge.checkmark", isSecure: false, keyboardType: .numberPad)
                    .onChange(of: dealerNumber) { _, v in
                        let digits = v.filter { $0.isNumber }
                        if v != digits { dealerNumber = digits }
                    }
                if !dealerNumber.isEmpty {
                    PrimaryActionButton(title: "다음", titleFont: .system(size: 18, weight: .semibold), height: 32) {
                        if dealerNumber == "0000" { errorMessage = nil; onNext() }
                        else { errorMessage = "딜러 번호가 올바르지 않습니다. (0000)" }
                    }
                }
            }
        }
    }
}

