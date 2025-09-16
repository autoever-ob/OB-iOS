//
//  CustomConfirmationModal.swift
//  campick
//
//  Created by 김호집 on 9/16/25.
//

import SwiftUI

struct CustomConfirmationModal: View {
    let title: String
    let message: String
    let confirmButtonText: String
    let cancelButtonText: String
    let isDestructive: Bool
    let onConfirm: () -> Void
    let onCancel: () -> Void

    @State private var showModal = false

    var body: some View {
        ZStack {
            // Background overlay
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.easeOut(duration: 0.3)) {
                        showModal = false
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        onCancel()
                    }
                }

            // Modal content
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 16) {
                    // Icon
                    Image(systemName: isDestructive ? "exclamationmark.triangle.fill" : "questionmark.circle.fill")
                        .font(.system(size: 36))
                        .foregroundColor(isDestructive ? .red : AppColors.brandOrange)

                    // Title
                    Text(title)
                        .foregroundColor(.white)
                        .font(.system(size: 17, weight: .bold))

                    // Message
                    Text(message)
                        .foregroundColor(.white.opacity(0.8))
                        .font(.system(size: 13))
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                }
                .padding(.horizontal, 32)
                .padding(.top, 32)
                .padding(.bottom, 24)

                // Buttons
                VStack(spacing: 12) {
                    // Confirm button
                    Button(action: {
                        withAnimation(.easeOut(duration: 0.2)) {
                            showModal = false
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            onConfirm()
                        }
                    }) {
                        Text(confirmButtonText)
                            .foregroundColor(.white)
                            .font(.system(size: 14, weight: .semibold))
                            .frame(maxWidth: .infinity, minHeight: 44)
                            .background(
                                LinearGradient(
                                    colors: isDestructive ?
                                        [Color.red, Color.red.opacity(0.8)] :
                                        [AppColors.brandOrange, AppColors.brandLightOrange],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }

                    // Cancel button
                    Button(action: {
                        withAnimation(.easeOut(duration: 0.2)) {
                            showModal = false
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            onCancel()
                        }
                    }) {
                        Text(cancelButtonText)
                            .foregroundColor(.white.opacity(0.8))
                            .font(.system(size: 14))
                            .frame(maxWidth: .infinity, minHeight: 44)
                            .background(Color.white.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            )
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
            .background(AppColors.background)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
            .frame(maxWidth: 320)
            .scaleEffect(showModal ? 1.0 : 0.7)
            .opacity(showModal ? 1.0 : 0.0)
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0)) {
                showModal = true
            }
        }
    }
}

// 로그아웃 전용 모달
struct LogoutModal: View {
    let onConfirm: () -> Void
    let onCancel: () -> Void

    var body: some View {
        CustomConfirmationModal(
            title: "로그아웃",
            message: "정말로 로그아웃 하시겠습니까?",
            confirmButtonText: "로그아웃",
            cancelButtonText: "취소",
            isDestructive: false,
            onConfirm: onConfirm,
            onCancel: onCancel
        )
    }
}

// 회원탈퇴 전용 모달
struct WithdrawalModal: View {
    let onConfirm: () -> Void
    let onCancel: () -> Void

    @State private var confirmText = ""
    @State private var showModal = false
    private let requiredText = "이 앱을 탈퇴하겠습니다"

    var body: some View {
        ZStack {
            // Background overlay
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.easeOut(duration: 0.3)) {
                        showModal = false
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        onCancel()
                    }
                }

            // Modal content
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 16) {
                    // Icon
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 48))
                        .foregroundColor(.red)

                    // Title
                    Text("회원 탈퇴")
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .bold))

                    // Message
                    Text("정말로 회원 탈퇴를 하시겠습니까?\n\n탈퇴 후에는 모든 데이터가 삭제되며\n복구할 수 없습니다.")
                        .foregroundColor(.white.opacity(0.8))
                        .font(.system(size: 14))
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)

                    // Confirmation text instruction
                    VStack(spacing: 8) {
                        Text("탈퇴를 원하시면 아래 문구를 정확히 입력해주세요:")
                            .foregroundColor(.white.opacity(0.7))
                            .font(.system(size: 12))

                        Text("\"\(requiredText)\"")
                            .foregroundColor(.red)
                            .font(.system(size: 13, weight: .semibold))

                        // Text input field
                        TextField("", text: $confirmText)
                            .textFieldStyle(PlainTextFieldStyle())
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.white.opacity(0.1))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
                .padding(.horizontal, 32)
                .padding(.top, 32)
                .padding(.bottom, 24)

                // Buttons
                VStack(spacing: 12) {
                    // Confirm button (disabled if text doesn't match)
                    Button(action: {
                        if confirmText == requiredText {
                            withAnimation(.easeOut(duration: 0.2)) {
                                showModal = false
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                onConfirm()
                            }
                        }
                    }) {
                        Text("탈퇴하기")
                            .foregroundColor(.white)
                            .font(.system(size: 14, weight: .semibold))
                            .frame(maxWidth: .infinity, minHeight: 44)
                            .background(
                                LinearGradient(
                                    colors: confirmText == requiredText ?
                                        [Color.red, Color.red.opacity(0.8)] :
                                        [Color.gray, Color.gray.opacity(0.8)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .disabled(confirmText != requiredText)

                    // Cancel button
                    Button(action: {
                        withAnimation(.easeOut(duration: 0.2)) {
                            showModal = false
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            onCancel()
                        }
                    }) {
                        Text("취소")
                            .foregroundColor(.white.opacity(0.8))
                            .font(.system(size: 14))
                            .frame(maxWidth: .infinity, minHeight: 44)
                            .background(Color.white.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            )
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
            .background(AppColors.background)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
            .frame(maxWidth: 320)
            .scaleEffect(showModal ? 1.0 : 0.7)
            .opacity(showModal ? 1.0 : 0.0)
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0)) {
                showModal = true
            }
        }
    }
}

#Preview {
    ZStack {
        AppColors.background
            .ignoresSafeArea()

        LogoutModal(
            onConfirm: { print("로그아웃 확인") },
            onCancel: { print("로그아웃 취소") }
        )
    }
}
