//
//  NicknameStepView.swift
//  campick
//
//  Created by Admin on 9/17/25.
//

import SwiftUI

struct NicknameStepView: View {
    @Binding var nickname: String
    @Binding var selectedImage: UIImage?
    @Binding var showCamera: Bool
    @Binding var showGallery: Bool
    @Binding var isSubmitting: Bool
    @Binding var submitError: String?
    var onNext: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            ZstackAvatar
                .padding(.vertical, 40)

            HStack(spacing: 10) {
                PrimaryActionButton(title: "사진 찍기", titleFont: .system(size: 14, weight: .semibold), systemImage: "camera", width: 120, height: 28) {
                    if UIImagePickerController.isSourceTypeAvailable(.camera) { showCamera = true }
                }
                PrimaryActionButton(title: "갤러리", titleFont: .system(size: 14, weight: .semibold), systemImage: "photo.on.rectangle", width: 120, height: 28) {
                    showGallery = true
                }
            }

            VStack(alignment: .leading, spacing: 10) {
                Text("닉네임").foregroundStyle(.white.opacity(0.9)).bold()
                OutlinedInputField(text: $nickname, placeholder: "닉네임을 입력하세요 (2자 이상)", systemImage: "person", isSecure: false)
            }

            if nickname.trimmingCharacters(in: .whitespaces).count >= 2 {
                PrimaryActionButton(
                    title: isSubmitting ? "처리 중..." : "가입 완료",
                    titleFont: .system(size: 18, weight: .semibold),
                    height: 28,
                    isDisabled: isSubmitting
                ) { onNext() }
            }
            if let submitError {
                Text(submitError)
                    .font(.footnote)
                    .foregroundStyle(.red)
            }
        }
        .sheet(isPresented: $showCamera) { MediaPickerSheet(source: .camera, selectedImage: $selectedImage) }
        .sheet(isPresented: $showGallery) { MediaPickerSheet(source: .photoLibrary, selectedImage: $selectedImage) }
    }

    private var ZstackAvatar: some View {
        ZStack {
            if let uiImage = selectedImage {
                Image(uiImage: uiImage).resizable().scaledToFill()
            } else {
                Image(systemName: "person.crop.circle.fill").resizable().scaledToFit().foregroundColor(.white.opacity(0.3)).padding(20)
            }
        }
        .frame(width: 120, height: 120)
        .background(Color.white.opacity(0.06))
        .clipShape(Circle())
        .overlay(Circle().stroke(Color.white.opacity(0.2), lineWidth: 1))
    }
}
