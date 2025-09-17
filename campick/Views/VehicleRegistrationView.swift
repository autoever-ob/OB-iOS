//
//  VehicleRegistrationView.swift
//  campick
//
//  Refactored on 9/17/25.
//

import SwiftUI
import PhotosUI
import UIKit

struct VehicleRegistrationView: View {
    @State private var vehicleImages: [VehicleImage] = []
    @State private var selectedPhotos: [PhotosPickerItem] = []
    @State private var title: String = ""
    @State private var mileage: String = ""
    @State private var vehicleType: String = ""
    @State private var price: String = ""
    @State private var description: String = ""
    @State private var showingVehicleTypePicker = false
    @State private var showingImagePicker = false
    @State private var showingCamera = false
    @State private var errors: [String: String] = [:]
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            AppColors.background
                .ignoresSafeArea()

            VStack(spacing: 0) {
                VehicleRegistrationHeader(onCameraAction: {
                    showingCamera = true
                })
                ScrollView {
                    VStack(spacing: 24) {
                        VehicleRegistrationTitleSection()

                        VehicleImageUploadSection(
                            vehicleImages: $vehicleImages,
                            selectedPhotos: $selectedPhotos,
                            showingImagePicker: $showingImagePicker,
                            errors: $errors
                        )
                        .onChange(of: selectedPhotos) { _, newItems in
                            loadSelectedPhotos(newItems)
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            FieldLabel(text: "매물 제목")

                            StyledInputContainer(hasError: errors["title"] != nil) {
                                TextField("매물 제목을 입력하세요", text: $title)
                                    .foregroundColor(.white)
                                    .font(.system(size: 14))
                                    .padding(.horizontal, 12)
                            }

                            ErrorText(message: errors["title"])
                        }

                        VehicleInputField(
                            title: "주행거리",
                            placeholder: "주행거리를 입력하세요",
                            text: $mileage,
                            keyboardType: .numberPad,
                            suffix: "km",
                            errors: errors,
                            errorKey: "mileage",
                            formatNumber: formatNumber
                        )

                        VehicleTypeSection(
                            vehicleType: $vehicleType,
                            showingVehicleTypePicker: $showingVehicleTypePicker,
                            errors: errors
                        )

                        VehicleInputField(
                            title: "판매 가격",
                            placeholder: "가격을 입력하세요",
                            text: $price,
                            keyboardType: .numberPad,
                            suffix: "만원",
                            errors: errors,
                            errorKey: "price",
                            formatNumber: formatNumber
                        )

                        VStack(alignment: .leading, spacing: 4) {
                            FieldLabel(text: "상세 설명")

                            StyledTextEditorContainer(
                                hasError: errors["description"] != nil,
                                placeholder: "차량에 대한 상세한 설명을 입력하세요",
                                text: $description
                            )

                            ErrorText(message: errors["description"])
                        }

                        VehicleSubmitButton(action: handleSubmit)
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 32)
                }
            }
        }
        .sheet(isPresented: $showingVehicleTypePicker) {
            VehicleTypePicker(
                vehicleType: $vehicleType,
                showingVehicleTypePicker: $showingVehicleTypePicker,
                errors: $errors
            )
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

    private func formatNumber(_ value: String) -> String {
        let numbers = value.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal

        if let number = Int(numbers), number > 0 {
            return formatter.string(from: NSNumber(value: number)) ?? numbers
        }
        return ""
    }

    private func loadSelectedPhotos(_ items: [PhotosPickerItem]) {
        for item in items {
            item.loadTransferable(type: Data.self) { result in
                switch result {
                case .success(let data):
                    if let data = data, let uiImage = UIImage(data: data) {
                        DispatchQueue.main.async {
                            addImage(uiImage)
                        }
                    }
                case .failure(let error):
                    print("Error loading image: \(error)")
                }
            }
        }
        selectedPhotos.removeAll()
    }

    private func addImage(_ image: UIImage) {
        let newImage = VehicleImage(image: image, isMain: vehicleImages.isEmpty)
        vehicleImages.append(newImage)
        errors["images"] = nil
    }

    private func handleSubmit() {
        var newErrors: [String: String] = [:]

        if title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            newErrors["title"] = "매물 제목을 입력해주세요"
        }

        if vehicleImages.isEmpty {
            newErrors["images"] = "최소 1장의 이미지를 업로드해주세요"
        }

        if mileage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            newErrors["mileage"] = "주행거리를 입력해주세요"
        }

        if vehicleType.isEmpty {
            newErrors["vehicleType"] = "차량 종류를 선택해주세요"
        }

        if price.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            newErrors["price"] = "판매 가격을 입력해주세요"
        }

        if description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            newErrors["description"] = "상세 설명을 입력해주세요"
        }

        errors = newErrors

        if errors.isEmpty {
            print("매물 등록 성공!")
            dismiss()
        }
    }
}

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

#Preview {
    VehicleRegistrationView()
}