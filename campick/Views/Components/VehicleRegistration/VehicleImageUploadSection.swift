//
//  VehicleImageUploadSection.swift
//  campick
//
//  Created by 김호집 on 9/17/25.
//

import SwiftUI
import PhotosUI
import UIKit

struct VehicleImageUploadSection: View {
    @Binding var vehicleImages: [VehicleImage]
    @Binding var selectedPhotos: [PhotosPickerItem]
    @Binding var showingImagePicker: Bool
    @Binding var errors: [String: String]
    @State private var showingCamera = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                FieldLabel(text: "차량 이미지")

                Spacer()

                Text("\(vehicleImages.count)/10")
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.6))
            }

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 3), spacing: 8) {
                ForEach(vehicleImages) { vehicleImage in
                    imageItemView(vehicleImage)
                }

                if vehicleImages.count < 10 {
                    addImageButtons
                }

                if vehicleImages.count < 9 {
                    cameraButton
                }
            }

            ErrorText(message: errors["images"])
        }
        .onChange(of: selectedPhotos) { _, newItems in
            loadSelectedPhotos(newItems)
        }
        .fullScreenCover(isPresented: $showingCamera) {
            CameraView { image in
                if let image = image {
                    addImage(image)
                }
                showingCamera = false
            }
        }
    }

    private func imageItemView(_ vehicleImage: VehicleImage) -> some View {
        ZStack {
            Image(uiImage: vehicleImage.image)
                .resizable()
                .aspectRatio(1, contentMode: .fill)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()
                .cornerRadius(8)

            if vehicleImage.isMain {
                VStack {
                    HStack {
                        Text("메인")
                            .font(.system(size: 10))
                            .foregroundColor(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(AppColors.brandOrange)
                            .cornerRadius(4)

                        Spacer()
                    }

                    Spacer()
                }
                .padding(4)
            }

            VStack {
                HStack {
                    Spacer()

                    VStack(spacing: 4) {
                        if !vehicleImage.isMain {
                            Button(action: { setMainImage(vehicleImage) }) {
                                ZStack {
                                    Circle()
                                        .fill(AppColors.primaryText.opacity(0.8))
                                        .frame(width: 20, height: 20)

                                    Image(systemName: "star")
                                        .font(.system(size: 10))
                                        .foregroundColor(.gray)
                                }
                            }
                        }

                        Button(action: { deleteImage(vehicleImage) }) {
                            ZStack {
                                Circle()
                                    .fill(Color.red)
                                    .frame(width: 20, height: 20)

                                Image(systemName: "xmark")
                                    .font(.system(size: 10))
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }

                Spacer()
            }
            .padding(4)
        }
        .aspectRatio(1, contentMode: .fit)
    }

    private var addImageButtons: some View {
        PhotosPicker(selection: $selectedPhotos, maxSelectionCount: 10 - vehicleImages.count, matching: .images) {
            VStack(spacing: 4) {
                Image(systemName: "photo.on.rectangle.angled")
                    .font(.system(size: 20))
                    .foregroundColor(.white.opacity(0.6))

                Text("갤러리")
                    .font(.system(size: 10))
                    .foregroundColor(.white.opacity(0.6))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .aspectRatio(1, contentMode: .fit)
            .background(AppColors.brandBackground.opacity(0.5))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(AppColors.primaryText.opacity(0.2), lineWidth: 1)
            )
        }
        .frame(height: 80)
    }

    private var cameraButton: some View {
        Button(action: {
            showingCamera = true
        }) {
            VStack(spacing: 4) {
                Image(systemName: "camera.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.white.opacity(0.6))

                Text("카메라")
                    .font(.system(size: 10))
                    .foregroundColor(.white.opacity(0.6))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .aspectRatio(1, contentMode: .fit)
            .background(AppColors.brandBackground.opacity(0.5))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(AppColors.primaryText.opacity(0.2), lineWidth: 1)
            )
        }
        .frame(height: 80)
    }

    private func setMainImage(_ vehicleImage: VehicleImage) {
        for i in vehicleImages.indices {
            vehicleImages[i].isMain = (vehicleImages[i].id == vehicleImage.id)
        }
    }

    private func deleteImage(_ vehicleImage: VehicleImage) {
        vehicleImages.removeAll { $0.id == vehicleImage.id }

        if vehicleImage.isMain && !vehicleImages.isEmpty {
            vehicleImages[0].isMain = true
        }
    }

    private func addImage(_ image: UIImage) {
        let newImage = VehicleImage(image: image, isMain: vehicleImages.isEmpty)
        vehicleImages.append(newImage)
        errors["images"] = nil
    }

    private func loadSelectedPhotos(_ items: [PhotosPickerItem]) {
        for item in items {
            item.loadTransferable(type: Data.self) { result in
                switch result {
                case .success(let data):
                    if let data = data, let uiImage = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.addImage(uiImage)
                        }
                    }
                case .failure(let error):
                    print("Error loading image: \(error)")
                }
            }
        }
        selectedPhotos.removeAll()
    }
}

// CameraView 정의
struct CameraView: UIViewControllerRepresentable {
    let onImageCaptured: (UIImage?) -> Void

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        picker.allowsEditing = false
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraView

        init(_ parent: CameraView) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.onImageCaptured(image)
            } else {
                parent.onImageCaptured(nil)
            }
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.onImageCaptured(nil)
        }
    }
}