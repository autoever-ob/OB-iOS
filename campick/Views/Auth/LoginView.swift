//
//  Untitled.swift
//  campick
//
//  Created by Admin on 9/15/25.
//

import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var keepLoggedIn: Bool = false
    @State private var goHome = false
    @StateObject private var userState = UserState.shared
    @State private var isLoading = false
    @State private var errorMessage: String? = nil
    @State private var showServerAlert: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()
                VStack(spacing: 4) {
                    VStack {
                        Text("Campick")
                            .font(.basicFont(size: 40))
                            .foregroundStyle(.white)

                        Text("프리미엄 캠핑카 플랫폼")
                            .font(.subheadline)
                            .foregroundStyle(.white)

                        VStack(spacing: 8) {
                            // 이메일
                            FormLabel(text: "이메일")
                            OutlinedInputField(text: $email, placeholder: "이메일을 입력하세요", systemImage: "envelope")
                                .padding(.bottom, 16)

                            // 비밀번호
                            FormLabel(text: "비밀번호")
                            OutlinedInputField(text: $password, placeholder: "비밀번호를 입력하세요", isSecure: true)

                            // 로그인 유지 체크박스
                            HStack {
                                Button(action: { keepLoggedIn.toggle() }) {
                                    HStack(spacing: 4) {
                                        Image(systemName: keepLoggedIn ? "checkmark.square.fill" : "square")
                                            .font(.system(size: 20, weight: .semibold))
                                            .foregroundStyle(keepLoggedIn ? AppColors.brandOrange : .white.opacity(0.9))
                                        Text("로그인 유지")
                                            .foregroundStyle(.white)
                                            .font(.subheadline)
                                    }
                                }
                                .buttonStyle(.plain)
                                .accessibilityLabel("로그인 유지")
                                .accessibilityValue(keepLoggedIn ? "선택됨" : "선택 안 됨")
                                Spacer()
                                
                                // 비밀번호 찾기
                                NavigationLink {
                                    FindPasswordView()
                                } label: {
                                    Text("비밀번호 찾기")
                                        .font(Font.subheadline.bold())
                                        .foregroundStyle(AppColors.brandOrange)
                                }
                            }
                            .padding(.top, 12)
                            .padding(.bottom, 12)
                            .padding(.horizontal, 2)

                            // 로그인 버튼
                            PrimaryActionButton(
                                title: "로그인",
                                titleFont: .system(size: 18, weight: .bold),
                                isDisabled: email.isEmpty || password.isEmpty || isLoading,
                            ) {
                                handleLogin()
                            }
                            if let errorMessage {
                                Text(errorMessage)
                                    .font(.footnote)
                                    .foregroundStyle(.red)
                            }
                            
                            // 구분선
                            HStack(spacing: 16) {
                                Rectangle()
                                    .fill(Color.white.opacity(0.28))
                                    .frame(height: 1)
                                    .frame(maxWidth: .infinity)
                                    .accessibilityHidden(true)

                                Text("또는")
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(.white.opacity(0.6))

                                Rectangle()
                                    .fill(Color.white.opacity(0.28))
                                    .frame(height: 1)
                                    .frame(maxWidth: .infinity)
                                    .accessibilityHidden(true)
                            }
                            .padding(.vertical, 8)
                            
                            HStack {
                                Text("아직 계정이 없으신가요?")
                                    .font(Font.subheadline.bold())
                                    .foregroundStyle(Color.gray)
                                // 회원가입
                                NavigationLink {
                                    SignupFlowView()
                                } label: {
                                    Text("회원가입")
                                        .font(Font.subheadline.bold())
                                        .foregroundStyle(AppColors.brandOrange)
                                }
                            }
                            Spacer()
                        }
                        .padding(.top, 48)
                        .padding(.horizontal, 24)
                    }
                    .padding(.top, 112)
                }
            }
            .alert("서버 연결이 불안정합니다. 잠시후 다시 시도해 주세요", isPresented: $showServerAlert) {
                Button("확인", role: .cancel) {}
            }
        }
    }

    private func handleLogin() {
        isLoading = true
        errorMessage = nil
        Task {
            do {
                let res = try await AuthAPI.login(email: email, password: password)
                TokenManager.shared.saveAccessToken(res.accessToken)

                let u = res.user
                let name = u?.name ?? u?.nickname ?? ""
                let nick = u?.nickname ?? u?.name ?? ""
                let phone = u?.mobileNumber ?? ""
                let memberId = u?.memberId ?? u?.id ?? ""
                let dealerId = u?.dealerId ?? ""
                let role = u?.role ?? ""

                userState.saveUserData(
                    name: name,
                    nickName: nick,
                    phoneNumber: phone,
                    memberId: memberId,
                    dealerId: dealerId,
                    role: role
                )
            } catch {
                if let appError = error as? AppError {
                    errorMessage = appError.message
                    switch appError {
                    case .cannotConnect, .hostNotFound, .network:
                        showServerAlert = true
                    default:
                        break
                    }
                } else {
                    errorMessage = error.localizedDescription
                }
            }
            isLoading = false
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
