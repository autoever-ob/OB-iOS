//
//  PasswordChangeView.swift
//  campick
//
//  Created by 김호집 on 9/16/25.
//

import SwiftUI

struct PasswordChangeView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var currentStep = 0
    @State private var currentPassword = ""
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        ZStack {
            AppColors.background
                .ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    Button(action: {
                        if currentStep > 0 {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentStep -= 1
                            }
                        } else {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .font(.system(size: 16))
                    }

                    Spacer()

                    Text(currentStep == 0 ? "현재 비밀번호 확인" : "새 비밀번호 설정")
                        .foregroundColor(.white)
                        .font(.system(size: 18, weight: .semibold))

                    Spacer()

                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .font(.system(size: 16))
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                .padding(.bottom, 24)

                TabView(selection: $currentStep) {
                    CurrentPasswordStep(
                        currentPassword: $currentPassword,
                        onNext: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentStep = 1
                            }
                        }
                    )
                    .tag(0)

                    NewPasswordStep(
                        newPassword: $newPassword,
                        confirmPassword: $confirmPassword,
                        onComplete: {
                            if newPassword == confirmPassword && !newPassword.isEmpty {
                                alertMessage = "비밀번호가 성공적으로 변경되었습니다."
                                showAlert = true
                            } else {
                                alertMessage = "비밀번호가 일치하지 않습니다."
                                showAlert = true
                            }
                        }
                    )
                    .tag(1)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.3), value: currentStep)
            }
        }
        .navigationBarHidden(true)
        .alert("알림", isPresented: $showAlert) {
            Button("확인") {
                if alertMessage.contains("성공적으로") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        } message: {
            Text(alertMessage)
        }
    }
}

struct CurrentPasswordStep: View {
    @Binding var currentPassword: String
    let onNext: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 16) {
                Text("현재 비밀번호를 입력해주세요")
                    .foregroundColor(.white.opacity(0.8))
                    .font(.system(size: 16))
                    .multilineTextAlignment(.center)

                SecureField("현재 비밀번호", text: $currentPassword)
                    .foregroundColor(.white)
                    .padding(16)
                    .background(Color.gray.opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }

            Spacer()

            Button(action: onNext) {
                Text("확인")
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .semibold))
                    .frame(maxWidth: .infinity, minHeight: 48)
                    .background(
                        LinearGradient(
                            colors: currentPassword.isEmpty ?
                                [Color.gray.opacity(0.5), Color.gray.opacity(0.5)] :
                                [AppColors.brandOrange, AppColors.brandLightOrange],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .disabled(currentPassword.isEmpty)
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 40)
    }
}

struct NewPasswordStep: View {
    @Binding var newPassword: String
    @Binding var confirmPassword: String
    let onComplete: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 16) {
                Text("새로운 비밀번호를 입력해주세요")
                    .foregroundColor(.white.opacity(0.8))
                    .font(.system(size: 16))
                    .multilineTextAlignment(.center)

                SecureField("새 비밀번호", text: $newPassword)
                    .foregroundColor(.white)
                    .padding(16)
                    .background(Color.gray.opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: 8))

                SecureField("새 비밀번호 확인", text: $confirmPassword)
                    .foregroundColor(.white)
                    .padding(16)
                    .background(Color.gray.opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: 8))

                if !newPassword.isEmpty && !confirmPassword.isEmpty {
                    HStack {
                        Image(systemName: newPassword == confirmPassword ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundColor(newPassword == confirmPassword ? .green : .red)
                        Text(newPassword == confirmPassword ? "비밀번호가 일치합니다" : "비밀번호가 일치하지 않습니다")
                            .foregroundColor(newPassword == confirmPassword ? .green : .red)
                            .font(.system(size: 14))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }

            Spacer()

            Button(action: onComplete) {
                Text("비밀번호 변경")
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .semibold))
                    .frame(maxWidth: .infinity, minHeight: 48)
                    .background(
                        LinearGradient(
                            colors: (newPassword.isEmpty || confirmPassword.isEmpty || newPassword != confirmPassword) ?
                                [Color.gray.opacity(0.5), Color.gray.opacity(0.5)] :
                                [AppColors.brandOrange, AppColors.brandLightOrange],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .disabled(newPassword.isEmpty || confirmPassword.isEmpty || newPassword != confirmPassword)
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 40)
    }
}
