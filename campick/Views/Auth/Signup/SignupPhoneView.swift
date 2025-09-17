//
//  SignupPhoneView.swift
//  campick
//
//  Created by Admin on 9/17/25.
//

import SwiftUI

struct SignupPhoneView: View {
    let userType: UserType
    let email: String
    let password: String

    @Environment(\.dismiss) private var dismiss

    @State private var phone: String = ""
    @State private var showCodeField = false
    @State private var code: String = ""
    @State private var codeVerified = false
    @State private var errorMessage: String? = nil

    // Dealer only
    @State private var showDealerField = false
    @State private var dealerNumber: String = ""

    @State private var goNickname = false

    var body: some View {
        ZStack {
            AppColors.brandBackground.ignoresSafeArea()
            VStack(spacing: 0) {
                TopBarView(title: "휴대폰 인증") { dismiss() }
                SignupProgressView(progress: 0.75)
                    .padding(.top, 20)
                    .padding(.bottom, 18)
                    .padding(.horizontal, 14)

                VStack(alignment: .leading, spacing: 10) {
                    Text("휴대폰 번호")
                        .foregroundStyle(.white.opacity(0.9)).bold()
                    HStack(spacing: 8) {
                        OutlinedInputField(text: $phone, placeholder: "휴대폰 번호 입력", systemImage: "phone", isSecure: false, keyboardType: .numberPad)
                            .onChange(of: phone) { _, v in
                                let digits = v.filter { $0.isNumber }
                                if v != digits { phone = digits }
                            }
                        
                        PrimaryActionButton(
                            title: "인증하기",
                            titleFont: .system(size: 16, weight: .semibold),
                            height: 24, isDisabled: phone.isEmpty
                        ) {
                            showCodeField = true
                        }
                        .frame(width: 100)
                    }

                    if showCodeField {
                        Text("인증번호")
                            .foregroundStyle(.white.opacity(0.9)).bold()
                        OutlinedInputField(text: $code, placeholder: "인증번호", systemImage: "number", isSecure: false, keyboardType: .numberPad)
                            .onChange(of: code) { _, v in
                                let digits = v.filter { $0.isNumber }
                                if v != digits { code = digits }
                            }
                    }

                    // 딜러 전용 입력란은 코드 검증 성공 후 노출
                    if userType == .dealer && showDealerField {
                        Text("딜러 번호")
                            .foregroundStyle(.white.opacity(0.9)).bold()
                        OutlinedInputField(text: $dealerNumber, placeholder: "딜러 번호 입력", systemImage: "person.crop.circle.badge.checkmark", isSecure: false, keyboardType: .numberPad)
                            .onChange(of: dealerNumber) { _, v in
                                let digits = v.filter { $0.isNumber }
                                if v != digits { dealerNumber = digits }
                            }
                    }

                    if let errorMessage {
                        Text(errorMessage)
                            .foregroundStyle(.red)
                            .font(.caption)
                    }


                    // 1단계: 코드 입력 후 다음 버튼 → 코드 검증(0000)
                    if showCodeField && !code.isEmpty && !codeVerified {
                        PrimaryActionButton(
                            title: "다음",
                            titleFont: .system(size: 18, weight: .semibold),
                            height: 24,
                        ) {
                            let hasPhone = !phone.isEmpty
                            let codeOK = (code == "0000")
                            if hasPhone && codeOK {
                                errorMessage = nil
                                codeVerified = true
                                if userType == .dealer {
                                    showDealerField = true
                                } else {
                                    goNickname = true
                                }
                            } else {
                                errorMessage = "인증번호(0000) 또는 휴대폰 번호를 확인하세요."
                            }
                        }
                    }
                        

                    // 2단계(딜러): 딜러 번호 입력 후 다음 버튼 → 딜러 번호 검증(0000)
                    if userType == .dealer && showDealerField && !dealerNumber.isEmpty {
                        PrimaryActionButton(title: "다음", titleFont: .system(size: 18, weight: .semibold), height: 24) {
                            let dealerOK = (dealerNumber == "0000")
                            if dealerOK {
                                errorMessage = nil
                                goNickname = true
                            } else {
                                errorMessage = "딜러 번호가 올바르지 않습니다. (0000)"
                            }
                        }
                    }
                }
                .padding(.horizontal, 14)
                .navigationDestination(isPresented: $goNickname) {
                    SignupNicknameView()
                }

                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }
}

// MARK: - Preview
#Preview("SignupPhoneView") {
    NavigationStack {
        SignupPhoneView(userType: .dealer, email: "mock@example.com", password: "password123")
    }
}
