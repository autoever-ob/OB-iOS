//
//  SignupNicknameView.swift
//  campick
//
//  Created by Admin on 9/17/25.
//

import SwiftUI
import PhotosUI

struct SignupNicknameView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var nickname: String = ""
    @State private var selectedImage: UIImage? = nil
    @State private var showCamera = false
    @State private var showGallery = false
    @State private var goComplete = false

    var isValid: Bool { nickname.trimmingCharacters(in: .whitespaces).count >= 2 }

    var body: some View {
        ZStack {
            AppColors.brandBackground.ignoresSafeArea()
            VStack(spacing: 0) {
                TopBarView(title: "닉네임 설정") { dismiss() }
                SignupProgressView(progress: 1.0)
                    .padding(.top, 20)
                    .padding(.bottom, 18)
                    .padding(.horizontal, 14)

                VStack(spacing: 16) {
                    // 아바타
                    ZStack {
                        if let uiImage = selectedImage {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                        } else {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white.opacity(0.3))
                                .padding(20)
                        }
                    }
                    .frame(width: 120, height: 120)
                    .background(Color.white.opacity(0.06))
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white.opacity(0.2), lineWidth: 1))

                    HStack(spacing: 10) {
                        PrimaryActionButton(title: "사진 찍기", titleFont: .system(size: 14, weight: .semibold), systemImage: "camera", width: 120, height: 36) {
                            if UIImagePickerController.isSourceTypeAvailable(.camera) { showCamera = true }
                        }
                        PrimaryActionButton(title: "갤러리", titleFont: .system(size: 14, weight: .semibold), systemImage: "photo.on.rectangle", width: 120, height: 36) {
                            showGallery = true
                        }
                    }

                    VStack(alignment: .leading, spacing: 10) {
                        Text("닉네임")
                            .foregroundStyle(.white.opacity(0.9)).bold()
                        OutlinedInputField(text: $nickname, placeholder: "닉네임을 입력하세요 (2자 이상)", systemImage: "person", isSecure: false)
                    }

                    NavigationLink(destination: SignupCompleteView(), isActive: $goComplete) { EmptyView() }
                    PrimaryActionButton(title: "가입 완료", titleFont: .system(size: 18, weight: .semibold), height: 44, isDisabled: !isValid) {
                        goComplete = true
                    }
                }
                .padding(.horizontal, 14)

                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .sheet(isPresented: $showCamera) {
            ImagePickerView(sourceType: .camera, selectedImage: $selectedImage)
        }
        .sheet(isPresented: $showGallery) {
            ImagePickerView(sourceType: .photoLibrary, selectedImage: $selectedImage)
        }
    }
}
