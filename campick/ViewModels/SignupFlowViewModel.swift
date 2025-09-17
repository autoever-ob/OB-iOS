//
//  SignupFlowViewModel.swift
//  campick
//
//  Created by Admin on 9/17/25.
//

import SwiftUI

final class SignupFlowViewModel: ObservableObject {
    enum Step: Int { case email = 0, password, phone, nickname, complete }

    // Navigation / progress
    @Published var step: Step = .email
    @Published var prevProgress: CGFloat = 0.0

    var progress: CGFloat {
        switch step {
        case .email: return 0.25
        case .password: return 0.5
        case .phone: return 0.75
        case .nickname: return 0.9
        case .complete: return 1.0
        }
    }

    func go(to next: Step) {
        prevProgress = progress
        step = next
    }

    func title() -> String {
        switch step {
        case .email: return "회원가입"
        case .password: return "비밀번호 설정"
        case .phone: return "휴대폰 인증"
        case .nickname: return "닉네임 설정"
        case .complete: return "가입 완료"
        }
    }

    func goBack(_ dismiss: () -> Void) {
        switch step {
        case .email:
            dismiss()
        case .password:
            go(to: .email)
        case .phone:
            go(to: .password)
        case .nickname:
            go(to: .phone)
        case .complete:
            go(to: .nickname)
        }
    }

    // MARK: - Shared inputs
    @Published var userType: UserType? = nil

    // Email
    @Published var email: String = ""
    @Published var showEmailCodeField = false
    @Published var emailCode: String = ""

    func emailOnTapVerify() { showEmailCodeField = true }
    func emailOnChangeCode(_ value: String) { emailCode = value.filter { $0.isNumber } }
    func emailNext() { if !emailCode.isEmpty { go(to: .password) } }

    // Password
    @Published var password: String = ""
    @Published var confirm: String = ""
    @Published var passwordError: String? = nil
    func passwordNext() {
        if password.count >= 8 && confirm == password {
            passwordError = nil
            go(to: .phone)
        } else {
            passwordError = "비밀번호가 일치하지 않거나 8자 미만입니다."
        }
    }

    // Phone
    @Published var phone: String = ""
    @Published var showPhoneCodeField = false
    @Published var phoneCode: String = ""
    @Published var phoneError: String? = nil
    @Published var codeVerified = false
    @Published var showDealerField = false
    @Published var dealerNumber: String = ""

    func phoneOnTapVerify() { showPhoneCodeField = true }
    func phoneOnChangePhone(_ value: String) { phone = value.filter { $0.isNumber } }
    func phoneOnChangeCode(_ value: String) { phoneCode = value.filter { $0.isNumber } }
    func phoneNext() {
        let hasPhone = !phone.isEmpty
        let codeOK = (phoneCode == "0000")
        if hasPhone && codeOK {
            phoneError = nil
            codeVerified = true
            if userType == .dealer { showDealerField = true } else { go(to: .nickname) }
        } else {
            phoneError = "인증번호(0000) 또는 휴대폰 번호를 확인하세요."
        }
    }
    func dealerNext() {
        if dealerNumber == "0000" { phoneError = nil; go(to: .nickname) }
        else { phoneError = "딜러 번호가 올바르지 않습니다. (0000)" }
    }

    // Nickname
    @Published var nickname: String = ""
    @Published var selectedImage: UIImage? = nil
    @Published var showCamera = false
    @Published var showGallery = false
    var nicknameValid: Bool { nickname.trimmingCharacters(in: .whitespaces).count >= 2 }
    func nicknameNext() { if nicknameValid { go(to: .complete) } }
}

