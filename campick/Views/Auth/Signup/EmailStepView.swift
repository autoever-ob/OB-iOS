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
    @Binding var showMismatchModal: Bool
    @Binding var showDuplicateModal: Bool
    var onNext: () -> Void
    var onSend: () -> Void
    var onDuplicateLogin: () -> Void
    var onDuplicateFindPassword: () -> Void

    @StateObject private var vm = EmailStepViewModel()
    private let ticker = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @FocusState private var emailFocused: Bool
    @FocusState private var codeFocused: Bool
    @State private var activeAlert: AlertType?

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
                    OutlinedInputField(text: $email, placeholder: "이메일을 입력하세요", systemImage: "envelope", isSecure: false, keyboardType: .emailAddress, focus: $emailFocused)
                    let expired = showCodeField && vm.remainingSeconds == 0
                    PrimaryActionButton(title: expired ? "재전송" : "인증하기", titleFont: .system(size: 16, weight: .semibold), height: 22, isDisabled: email.isEmpty) {
                        showCodeField = true
                        showMismatchModal = false
                        vm.startTimer()
                        vm.resetExpiredNotice()
                        code = ""
                        onSend()
                        emailFocused = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { codeFocused = true }
                    }
                    .frame(width: 100)
                }
                if showCodeField {
                    Text("이메일 인증번호").foregroundStyle(.white.opacity(0.9)).bold()
                    OutlinedInputField(text: $code, placeholder: "인증번호", systemImage: "number", isSecure: false, keyboardType: .numberPad, focus: $codeFocused)
                        .onChange(of: code) { _, newValue in
                            let digits = newValue.filter { $0.isNumber }
                            if digits != newValue { code = digits }
                            vm.resetExpiredNotice()
                        }
                    // 남은 시간 표시 (3분 카운트다운) - 우측 정렬
                    HStack {
                        Spacer()
                        Image(systemName: "timer")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(vm.remainingSeconds > 0 ? .white.opacity(0.7) : .red)
                        Text(vm.timeString())
                            .font(.caption.bold())
                            .foregroundStyle(vm.remainingSeconds > 0 ? .white.opacity(0.7) : .red)
                    }
                    .padding(.top, 2)
                    
                    let isExpired = showCodeField && vm.remainingSeconds == 0
                    if vm.showExpiredNotice && isExpired {
                        Text("인증 시간이 만료되었습니다. 재전송 후 다시 입력해주세요.")
                            .font(.caption)
                            .foregroundStyle(.red)
                    }
                    if !code.isEmpty {
                        PrimaryActionButton(title: "다음", titleFont: .system(size: 18, weight: .semibold), height: 32) {
                            if isExpired {
                                vm.markExpired()
                                code = ""
                            } else {
                                onNext()
                            }
                        }
                    }
                }
            }
        }
        .onChange(of: showCodeField) { _, newValue in
            if newValue {
                vm.startTimer()
                codeFocused = true
            } else {
                vm.stopTimer()
            }
        }
        .onReceive(ticker) { _ in
            guard showCodeField else { return }
            vm.tick()
        }
        .onAppear { emailFocused = true }
        .onChange(of: showMismatchModal) { _, newValue in
            if newValue {
                vm.stopTimer()
                activeAlert = .mismatch
            } else if activeAlert == .mismatch {
                activeAlert = nil
            }
        }
        .onChange(of: showDuplicateModal) { _, newValue in
            if newValue {
                vm.stopTimer()
                showCodeField = false
                activeAlert = .duplicate
            } else if activeAlert == .duplicate {
                activeAlert = nil
            }
        }
        .alert(item: $activeAlert) { alert in
            switch alert {
            case .mismatch:
                return Alert(
                    title: Text("인증번호가 일치하지 않습니다."),
                    message: Text("받으신 인증번호를 다시 확인한 뒤 입력해주세요."),
                    dismissButton: .default(Text("다시 입력하기")) {
                        showMismatchModal = false
                        code = ""
                        vm.startTimer()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            codeFocused = true
                        }
                    }
                )
            case .duplicate:
                return Alert(
                    title: Text("이미 가입된 이메일입니다."),
                    message: Text("기존 계정으로 로그인하거나 비밀번호를 찾을 수 있습니다."),
                    primaryButton: .default(Text("다시 로그인하기")) {
                        showDuplicateModal = false
                        onDuplicateLogin()
                    },
                    secondaryButton: .default(Text("비밀번호를 찾으시겠습니까?")) {
                        showDuplicateModal = false
                        onDuplicateFindPassword()
                    }
                )
            }
        }
    }
}

private enum AlertType: Identifiable {
    case mismatch
    case duplicate

    var id: Int {
        switch self {
        case .mismatch: return 0
        case .duplicate: return 1
        }
    }
}
