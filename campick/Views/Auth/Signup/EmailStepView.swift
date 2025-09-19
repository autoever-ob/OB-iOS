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
    var onSend: () -> Void

    // 3분(180초) 카운트다운
    @State private var remainingSeconds: Int = 0
    @State private var timerActive: Bool = false
    @State private var showExpiredNotice: Bool = false
    private let ticker = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private var isExpired: Bool { showCodeField && remainingSeconds == 0 }
    @FocusState private var emailFocused: Bool
    @FocusState private var codeFocused: Bool

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
                    PrimaryActionButton(title: isExpired ? "재전송하기" : "인증하기", titleFont: .system(size: 16, weight: .semibold), height: 22, isDisabled: email.isEmpty) {
                        // 입력창 표시 및 타이머 시작(서버 응답 대기 없이 즉시)
                        showCodeField = true
                        showExpiredNotice = false
                        code = ""
                        startTimer()
                        onSend() // 서버에 발송 요청은 비동기 진행
                        // 포커스를 코드 입력으로 이동
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
                        }
                    // 남은 시간 표시 (3분 카운트다운) - 우측 정렬
                    HStack {
                        Spacer()
                        Image(systemName: "timer")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(remainingSeconds > 0 ? .white.opacity(0.7) : .red)
                        Text(timeString())
                            .font(.caption.bold())
                            .foregroundStyle(remainingSeconds > 0 ? .white.opacity(0.7) : .red)
                    }
                    .padding(.top, 2)
                    
                    if showExpiredNotice && isExpired {
                        Text("인증 시간이 만료되었습니다. 재전송 후 다시 입력해주세요.")
                            .font(.caption)
                            .foregroundStyle(.red)
                    }
                    if !code.isEmpty {
                        PrimaryActionButton(title: "다음", titleFont: .system(size: 18, weight: .semibold), height: 32) {
                            if isExpired {
                                // 만료 상태에서 다음을 누르면 재전송 유도
                                showExpiredNotice = true
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
            if newValue { startTimer(); codeFocused = true } else { stopTimer() }
        }
        .onReceive(ticker) { _ in
            guard showCodeField, timerActive, remainingSeconds > 0 else { return }
            remainingSeconds -= 1
            if remainingSeconds == 0 { timerActive = false }
        }
        .onAppear { emailFocused = true }
    }
}

private extension EmailStepView {
    func startTimer() {
        remainingSeconds = 180
        timerActive = true
    }
    func stopTimer() {
        timerActive = false
        remainingSeconds = 0
    }
    func timeString() -> String {
        let m = remainingSeconds / 60
        let s = remainingSeconds % 60
        return String(format: "%02d:%02d", m, s)
    }
}
