//
//  MediaPickerSheet.swift
//  campick
//
//  Created by Admin on 9/17/25.
//

import SwiftUI
import AVFoundation
import Photos

enum MediaSource {
    case camera
    case photoLibrary
}

struct MediaPickerSheet: View {
    let source: MediaSource
    @Binding var selectedImage: UIImage?

    @State private var cameraAuthorized: Bool = false
    @State private var checkedPermission = false

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Group {
            switch source {
            case .camera:
                if checkedPermission && cameraAuthorized {
                    ImagePickerView(sourceType: .camera, selectedImage: $selectedImage)
                } else if checkedPermission && !cameraAuthorized {
                    PermissionDeniedView(
                        title: "카메라 접근 권한 필요",
                        message: "설정 > 개인정보 보호 > 카메라에서 접근을 허용해주세요.",
                        onDismiss: { dismiss() }
                    )
                } else {
                    ProgressView().onAppear { checkCameraPermission() }
                }
            case .photoLibrary:
                // PhotosUI 기반 피커는 권한 없이도 동작하므로 바로 표시
                PhotoPickerView(selectedImage: $selectedImage)
            }
        }
    }

    private func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            cameraAuthorized = true; checkedPermission = true
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    self.cameraAuthorized = granted
                    self.checkedPermission = true
                }
            }
        case .denied, .restricted:
            cameraAuthorized = false; checkedPermission = true
        @unknown default:
            cameraAuthorized = false; checkedPermission = true
        }
    }
}

struct PermissionDeniedView: View {
    let title: String
    let message: String
    var onDismiss: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 40, weight: .bold))
                .foregroundStyle(.yellow)
            Text(title).font(.headline).foregroundStyle(.white)
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            HStack(spacing: 12) {
                PrimaryActionButton(title: "설정 열기", titleFont: .system(size: 16, weight: .semibold), width: 140, height: 40) {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }
                PrimaryActionButton(title: "닫기", titleFont: .system(size: 16, weight: .semibold), width: 100, height: 40, fill: .gray.opacity(0.4)) {
                    onDismiss?()
                }
            }
        }
        .padding()
        .background(AppColors.brandBackground)
    }
}

