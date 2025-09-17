//
//  SignupFlowView.swift
//  campick
//
//  Created by Admin on 9/17/25.
//

import SwiftUI

struct SignupFlowView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var vm = SignupFlowViewModel()
    @State private var goHome: Bool = false

    

    var body: some View {
        ZStack {
            AppColors.brandBackground.ignoresSafeArea()
            VStack(spacing: 0) {
                TopBarView(title: vm.title()) { vm.goBack { dismiss() } }

                SignupProgress(progress: vm.progress, startFrom: vm.prevProgress)
                    .padding(.top, 20)
                    .padding(.bottom, 18)
                    .padding(.horizontal, 14)

                Group {
                    switch vm.step {
                    case .email:
                        EmailStepView(userType: $vm.userType, email: $vm.email, showCodeField: $vm.showEmailCodeField, code: $vm.emailCode) { vm.emailNext() }
                    case .password:
                        PasswordStepView(password: $vm.password, confirm: $vm.confirm, errorMessage: $vm.passwordError) { vm.passwordNext() }
                    case .phone:
                        PhoneStepView(userType: $vm.userType, phone: $vm.phone, showCodeField: $vm.showPhoneCodeField, code: $vm.phoneCode, codeVerified: $vm.codeVerified, showDealerField: $vm.showDealerField, dealerNumber: $vm.dealerNumber, errorMessage: $vm.phoneError) { vm.go(to: .nickname) }
                    case .nickname:
                        NicknameStepView(nickname: $vm.nickname, selectedImage: $vm.selectedImage, showCamera: $vm.showCamera, showGallery: $vm.showGallery) { vm.go(to: .complete) }
                    case .complete:
                        CompleteStepView(onAutoForward: { goHome = true })
                    }
                }
                .padding(.horizontal, 14)

                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .navigationDestination(isPresented: $goHome) { HomeView() }
    }

    // Removed inline step views; see fileprivate step structs below
}

#Preview("SignupFlowView") {
    NavigationStack { SignupFlowView() }
}
