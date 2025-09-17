//
//  ProfileEditModal.swift
//  campick
//
//  Created by 김호집 on 9/16/25.
//

import SwiftUI

struct ProfileEditModal: View {
    @ObservedObject var viewModel: ProfileViewViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showImagePicker = false
    @State private var selectedImage: UIImage?

    var body: some View {
        ZStack {
            AppColors.background
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Custom Header
                HStack {
                    Spacer()

                    Text("프로필 수정")
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

                VStack(spacing: 16) {
                    // Profile Image Section with Camera Overlay
                    VStack(spacing: 12) {
                        Button(action: {
                            showImagePicker = true
                        }) {
                            ZStack {
                                if let selectedImage = selectedImage {
                                    Image(uiImage: selectedImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 80, height: 80)
                                        .clipShape(Circle())
                                } else {
                                    AsyncImage(url: URL(string: viewModel.userProfile.avatar)) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                    } placeholder: {
                                        Color.gray.opacity(0.3)
                                    }
                                    .frame(width: 80, height: 80)
                                    .clipShape(Circle())
                                }

                                Circle()
                                    .fill(Color.black.opacity(0.3))
                                    .frame(width: 80, height: 80)

                                Image(systemName: "camera.fill")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20))
                            }
                        }

                        Text("프로필 사진 변경")
                            .foregroundColor(.white.opacity(0.8))
                            .font(.system(size: 14))
                    }

                    // Form Fields (NO LOCATION FIELD as requested)
                    VStack(spacing: 12) {
                        FormField(
                            title: "닉네임",
                            text: $viewModel.editForm.name,
                            placeholder: "닉네임을 입력하세요"
                        )
                        FormField(
                            title: "자기소개",
                            text: $viewModel.editForm.bio,
                            placeholder: "자기소개를 입력하세요",
                            isMultiline: true
                        )
                        PhoneFormField(
                            title: "연락처",
                            text: $viewModel.editForm.phone,
                            placeholder: "010-1234-5678"
                        )
                    }

                    Spacer()

                    Button(action: {
                        // TODO: Save profile changes
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("저장하기")
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .semibold))
                            .frame(maxWidth: .infinity, minHeight: 48)
                            .background(
                                LinearGradient(
                                    colors: [AppColors.brandOrange, AppColors.brandLightOrange],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
        }
        .onAppear {
            // Initialize form with current profile data
            viewModel.editForm.name = viewModel.userProfile.name
            viewModel.editForm.bio = viewModel.userProfile.bio ?? ""
            viewModel.editForm.phone = viewModel.userProfile.phone ?? ""
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: $selectedImage)
        }
    }
}

struct FormField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    let isMultiline: Bool

    init(title: String, text: Binding<String>, placeholder: String, isMultiline: Bool = false) {
        self.title = title
        self._text = text
        self.placeholder = placeholder
        self.isMultiline = isMultiline
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .foregroundColor(.white.opacity(0.8))
                .font(.system(size: 14))

            if isMultiline {
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.3))
                        .frame(minHeight: 96)

                    CustomTextEditor(text: $text, placeholder: placeholder)
                        .padding(12)
                }
            } else {
                TextField(placeholder, text: $text)
                    .foregroundColor(.white)
                    .padding(12)
                    .background(Color.gray.opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) var presentationMode

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let editedImage = info[.editedImage] as? UIImage {
                parent.selectedImage = editedImage
            } else if let originalImage = info[.originalImage] as? UIImage {
                parent.selectedImage = originalImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct CustomTextEditor: UIViewRepresentable {
    @Binding var text: String
    let placeholder: String

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.backgroundColor = UIColor.clear
        textView.textColor = UIColor.white
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.isScrollEnabled = true
        textView.delegate = context.coordinator
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        if uiView.text != text {
            uiView.text = text
        }

        // Placeholder 처리
        if text.isEmpty {
            uiView.text = placeholder
            uiView.textColor = UIColor.white.withAlphaComponent(0.5)
        } else {
            uiView.textColor = UIColor.white
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextViewDelegate {
        let parent: CustomTextEditor

        init(_ parent: CustomTextEditor) {
            self.parent = parent
        }

        func textViewDidBeginEditing(_ textView: UITextView) {
            if textView.text == parent.placeholder {
                textView.text = ""
                textView.textColor = UIColor.white
            }
        }

        func textViewDidEndEditing(_ textView: UITextView) {
            if textView.text.isEmpty {
                textView.text = parent.placeholder
                textView.textColor = UIColor.white.withAlphaComponent(0.5)
            }
        }

        func textViewDidChange(_ textView: UITextView) {
            if textView.text != parent.placeholder {
                parent.text = textView.text
            }
        }
    }
}

struct PhoneFormField: View {
    let title: String
    @Binding var text: String
    let placeholder: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .foregroundColor(.white.opacity(0.8))
                .font(.system(size: 14))

            TextField(placeholder, text: $text)
                .foregroundColor(.white)
                .keyboardType(.numberPad)
                .padding(12)
                .background(Color.gray.opacity(0.3))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .onChange(of: text) { oldValue ,newValue in
                    // 숫자만 허용하고 자동으로 하이픈 추가
                    let filtered = newValue.filter { $0.isNumber }

                    if filtered.count <= 11 {
                        let formatted = formatPhoneNumber(filtered)
                        if formatted != newValue {
                            text = formatted
                        }
                    } else {
                        // 11자리 초과시 이전 값 유지
                        text = String(text.prefix(13)) // 010-1234-5678 형태로 최대 13자
                    }
                }
        }
    }

    private func formatPhoneNumber(_ numbers: String) -> String {
        let digits = numbers.filter { $0.isNumber }

        if digits.count <= 3 {
            return digits
        } else if digits.count <= 7 {
            let index = digits.index(digits.startIndex, offsetBy: 3)
            return String(digits[..<index]) + "-" + String(digits[index...])
        } else {
            let firstIndex = digits.index(digits.startIndex, offsetBy: 3)
            let secondIndex = digits.index(digits.startIndex, offsetBy: 7)
            return String(digits[..<firstIndex]) + "-" + String(digits[firstIndex..<secondIndex]) + "-" + String(digits[secondIndex...])
        }
    }
}
