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
    @State private var uploadedImageUrls: [String] = []
    @State private var selectedPhotos: [PhotosPickerItem] = []
    @State private var title: String = ""
    @State private var mileage: String = ""
    @State private var vehicleType: String = ""
    @State private var price: String = ""
    @State private var description: String = ""
    @State private var generation: String = ""
    @State private var vehicleModel: String = ""
    @State private var location: String = ""
    @State private var plateHash: String = ""
    @State private var vehicleOptions: [VehicleOption] = []
    @State private var showingVehicleTypePicker = false
    @State private var showingImagePicker = false
    @State private var showingOptionsPicker = false
    @State private var showingModelPicker = false
    @State private var errors: [String: String] = [:]
    @State private var isSubmitting = false
    @State private var showingSuccessAlert = false
    @State private var showingErrorAlert = false
    @State private var alertMessage = ""
    @State private var availableTypes: [String] = []
    @State private var availableModels: [String] = []
    @State private var availableOptions: [String] = []
    @State private var isLoadingProductInfo = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            AppColors.background
                .ignoresSafeArea()

            VStack(spacing: 0) {
                TopBarView(title: "차량매물등록") {
                    dismiss()
                }

                GeometryReader { geometry in
                    ScrollView {
                    VStack(spacing: 24) {
                        VehicleRegistrationTitleSection()

                        VehicleImageUploadSection(
                            vehicleImages: $vehicleImages,
                            uploadedImageUrls: $uploadedImageUrls,
                            selectedPhotos: $selectedPhotos,
                            showingImagePicker: $showingImagePicker,
                            errors: $errors
                        )

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
                            title: "연식",
                            placeholder: "연식을 입력하세요 (예: 2020)",
                            text: $generation,
                            keyboardType: .numberPad,
                            errors: errors,
                            errorKey: "generation"
                        )

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
                            errors: errors,
                            availableTypes: availableTypes
                        )

                        VehicleModelSection(
                            vehicleModel: $vehicleModel,
                            showingModelPicker: $showingModelPicker,
                            errors: errors,
                            availableModels: availableModels
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

                        VehicleInputField(
                            title: "판매 지역",
                            placeholder: "판매 지역을 입력하세요 (예: 서울시 강남구)",
                            text: $location,
                            errors: errors,
                            errorKey: "location"
                        )

                        PlateNumberInputField(
                            title: "차량 번호",
                            placeholder: "123가4567",
                            text: $plateHash,
                            errors: errors,
                            errorKey: "plateHash"
                        )

                        VehicleOptionsSection(
                            vehicleOptions: $vehicleOptions,
                            showingOptionsPicker: $showingOptionsPicker,
                            errors: errors
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

                        VehicleSubmitButton(action: handleSubmit, isLoading: isSubmitting)
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 120) // 하단 탭바(~80px) + 여유공간(40px)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: geometry.size.height)
                }
            }
        }
        .sheet(isPresented: $showingVehicleTypePicker) {
            VehicleTypePicker(
                vehicleType: $vehicleType,
                showingVehicleTypePicker: $showingVehicleTypePicker,
                errors: $errors,
                availableTypes: availableTypes
            )
        }
        .sheet(isPresented: $showingOptionsPicker) {
            VehicleOptionsPicker(
                vehicleOptions: $vehicleOptions,
                showingOptionsPicker: $showingOptionsPicker
            )
        }
        .sheet(isPresented: $showingModelPicker) {
            VehicleModelPicker(
                vehicleModel: $vehicleModel,
                showingModelPicker: $showingModelPicker,
                errors: $errors,
                availableModels: availableModels
            )
        }
        .alert("등록 완료", isPresented: $showingSuccessAlert) {
            Button("확인") {
                dismiss()
            }
        } message: {
            Text(alertMessage)
        }
        .alert("등록 실패", isPresented: $showingErrorAlert) {
            Button("확인") { }
        } message: {
            Text(alertMessage)
        }
        .navigationBarHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .task {
            await loadProductInfo()
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

    private func isValidKoreanPlate(_ plateNumber: String) -> Bool {
        let koreanPlateRegex = "^\\d{2,3}[가-힣]\\d{4}$"
        return plateNumber.range(of: koreanPlateRegex, options: .regularExpression) != nil
    }



    private func handleSubmit() {
        var newErrors: [String: String] = [:]

        if title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            newErrors["title"] = "매물 제목을 입력해주세요"
        }

        if vehicleImages.isEmpty {
            newErrors["images"] = "최소 1장의 이미지를 업로드해주세요"
        }

        if generation.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            newErrors["generation"] = "연식을 입력해주세요"
        }

        if mileage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            newErrors["mileage"] = "주행거리를 입력해주세요"
        }

        if vehicleType.isEmpty {
            newErrors["vehicleType"] = "차량 종류를 선택해주세요"
        }

        if vehicleModel.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            newErrors["vehicleModel"] = "차량 브랜드/모델을 입력해주세요"
        }

        if price.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            newErrors["price"] = "판매 가격을 입력해주세요"
        }

        if location.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            newErrors["location"] = "판매 지역을 입력해주세요"
        }

        let trimmedPlateHash = plateHash.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedPlateHash.isEmpty {
            newErrors["plateHash"] = "차량 번호를 입력해주세요"
        } else if !isValidKoreanPlate(trimmedPlateHash) {
            newErrors["plateHash"] = "올바른 번호판 형식을 입력하세요 (예: 123가4567)"
        }

        if description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            newErrors["description"] = "상세 설명을 입력해주세요"
        }

        errors = newErrors

        if errors.isEmpty {
            submitVehicleRegistration()
        }
    }

    private func submitVehicleRegistration() {
        isSubmitting = true

        // Use uploaded image URLs
        let mainImageUrl = uploadedImageUrls.first ?? ""
        let productImageUrls = Array(uploadedImageUrls.dropFirst())

        // Remove commas from numeric fields for API submission
        let cleanPrice = price.replacingOccurrences(of: ",", with: "")
        let cleanMileage = mileage.replacingOccurrences(of: ",", with: "")

        let request = VehicleRegistrationRequest(
            generation: generation,
            mileage: cleanMileage,
            vehicleType: vehicleType,
            vehicleModel: vehicleModel,
            price: cleanPrice,
            location: location,
            plateHash: plateHash,
            title: title,
            description: description,
            productImageUrl: productImageUrls,
            option: vehicleOptions,
            mainProductImageUrl: mainImageUrl
        )

        submitToAPI(request: request)
    }

    private func submitToAPI(request: VehicleRegistrationRequest) {
        guard let url = URL(string: Endpoint.registerProduct.url) else {
            print("Invalid URL")
            isSubmitting = false
            return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONEncoder().encode(request)
            urlRequest.httpBody = jsonData

            URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                DispatchQueue.main.async {
                    self.isSubmitting = false

                    if let error = error {
                        self.alertMessage = "네트워크 오류가 발생했습니다: \(error.localizedDescription)"
                        self.showingErrorAlert = true
                        return
                    }

                    guard let data = data else {
                        self.alertMessage = "서버로부터 응답을 받지 못했습니다."
                        self.showingErrorAlert = true
                        return
                    }

                    do {
                        let apiResponse = try JSONDecoder().decode(APIResponse<[String: String]>.self, from: data)

                        if apiResponse.success {
                            self.alertMessage = apiResponse.message
                            self.showingSuccessAlert = true
                        } else {
                            self.alertMessage = apiResponse.message
                            self.showingErrorAlert = true
                        }
                    } catch {
                        self.alertMessage = "응답 처리 중 오류가 발생했습니다."
                        self.showingErrorAlert = true
                    }
                }
            }.resume()

        } catch {
            alertMessage = "데이터 처리 중 오류가 발생했습니다."
            showingErrorAlert = true
            isSubmitting = false
        }
    }

    private func loadProductInfo() async {
        isLoadingProductInfo = true

        do {
            let productInfo = try await ProductAPI.fetchProductInfo()
            await MainActor.run {
                availableTypes = productInfo.type
                availableModels = productInfo.model
                availableOptions = productInfo.option
                // API에서 받아온 옵션들을 VehicleOption으로 변환
                vehicleOptions = productInfo.option.map { optionName in
                    VehicleOption(optionName: optionName, isInclude: false)
                }
                isLoadingProductInfo = false
            }
        } catch {
            await MainActor.run {
                print("Failed to load product info: \(error)")
                // 실패시 기본값 사용
                availableTypes = ["모터홈", "픽업트럭", "SUV"]
                availableModels = ["현대 포레스트", "기아 쏘렌토", "Toyota Hilux"]
                availableOptions = ["샤워실", "화장실", "침대", "주방", "에어컨"]
                // 기본 옵션들을 VehicleOption으로 변환
                vehicleOptions = availableOptions.map { optionName in
                    VehicleOption(optionName: optionName, isInclude: false)
                }
                isLoadingProductInfo = false
            }
        }
    }
}

#Preview {
    VehicleRegistrationView()
}
