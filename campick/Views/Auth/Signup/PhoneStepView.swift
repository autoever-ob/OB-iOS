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

    // Timer for phone code (3 minutes)
    @State private var remainingSeconds: Int = 0
    @State private var timerActive: Bool = false
    @State private var showExpiredNotice: Bool = false
    private let ticker = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private var isExpired: Bool { showCodeField && remainingSeconds == 0 }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("휴대폰 번호").foregroundStyle(.white.opacity(0.9)).bold()
            HStack(spacing: 8) {
                OutlinedInputField(text: $phone, placeholder: "휴대폰 번호 입력", systemImage: "phone", isSecure: false, keyboardType: .numberPad)
                    .onChange(of: phone) { _, v in
                        phone = formatPhone(v)
                    }
                PrimaryActionButton(title: isExpired ? "재전송하기" : "인증하기", titleFont: .system(size: 16, weight: .semibold), height: 24, isDisabled: !isValidPhone()) {
                    showCodeField = true
                    showExpiredNotice = false
                    code = ""
                    startTimer()
                }
                .frame(width: 100)
            }
            if showCodeField {
                Text("인증번호").foregroundStyle(.white.opacity(0.9)).bold()
                OutlinedInputField(text: $code, placeholder: "인증번호", systemImage: "number", isSecure: false, keyboardType: .default)
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
            }
            if let errorMessage {
                Text(errorMessage).foregroundStyle(.red).font(.caption)
            }
            if showCodeField && !code.isEmpty && !codeVerified {
                PrimaryActionButton(title: "다음", titleFont: .system(size: 18, weight: .semibold), height: 32) {
                    if isExpired {
                        showExpiredNotice = true
                        code = ""
                    } else {
                        let hasPhone = isValidPhone()
                        let codeOK = (code == "0000")
                        if hasPhone && codeOK {
                            errorMessage = nil
                            codeVerified = true
                            if userType == .dealer { showDealerField = true } else { onNext() }
                        } else {
                            errorMessage = "인증번호 또는 휴대폰 번호를 확인하세요."
                        }
                    }
                }
            }
            if showExpiredNotice && isExpired {
                Text("인증 시간이 만료되었습니다. 재전송 후 다시 입력해주세요.")
                    .font(.caption)
                    .foregroundStyle(.red)
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
        .onReceive(ticker) { _ in
            guard showCodeField, timerActive, remainingSeconds > 0 else { return }
            remainingSeconds -= 1
            if remainingSeconds == 0 { timerActive = false }
        }
    }
}

private extension PhoneStepView {
    func digitsOnly(_ s: String) -> String { s.filter { $0.isNumber } }
    func isValidPhone() -> Bool {
        let d = digitsOnly(phone)
        return d.count == 10 || d.count == 11
    }
    func formatPhone(_ input: String) -> String {
        let d = digitsOnly(input)
        if d.count <= 3 { return d }
        if d.count <= 7 {
            let a = String(d.prefix(3))
            let b = String(d.suffix(d.count - 3))
            return "\(a)-\(b)"
        }
        let a = String(d.prefix(3))
        let midLen = d.count == 11 ? 4 : 3
        let b = String(d.dropFirst(3).prefix(midLen))
        let c = String(d.dropFirst(3 + midLen))
        return c.isEmpty ? "\(a)-\(b)" : "\(a)-\(b)-\(c)"
    }
    func startTimer() { remainingSeconds = 180; timerActive = true }
    func timeString() -> String { String(format: "%02d:%02d", remainingSeconds/60, remainingSeconds%60) }
}
