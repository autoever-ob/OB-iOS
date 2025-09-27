import Foundation
import SwiftUI
import PhotosUI
import UIKit

@MainActor
final class VehicleRegistrationViewModel: ObservableObject {
    private let fetchMetadataUseCase: FetchVehicleMetadataUseCase
    private let createVehicleUseCase: CreateVehicleUseCase
    private let updateVehicleUseCase: UpdateVehicleUseCase
    private let fetchVehicleDetailUseCase: FetchVehicleDetailUseCase
    private let imageUploadService: ImageUploadService

    // Form fields
    @Published var vehicleImages: [VehicleImage] = []
    @Published var uploadedImageUrls: [String] = []
    @Published var selectedPhotos: [PhotosPickerItem] = []
    @Published var title: String = ""
    @Published var mileage: String = ""
    @Published var vehicleType: String = ""
    @Published var price: String = ""
    @Published var description: String = ""
    @Published var generation: String = ""
    @Published var vehicleModel: String = ""
    @Published var location: String = ""
    @Published var plateHash: String = ""
    @Published var vehicleOptions: [VehicleOption] = []

    // UI states
    @Published var showingVehicleTypePicker = false
    @Published var showingImagePicker = false
    @Published var showingOptionsPicker = false
    @Published var showingModelPicker = false
    @Published var errors: [String: String] = [:]
    @Published var isSubmitting = false
    @Published var showingSuccessAlert = false
    @Published var showingErrorAlert = false
    @Published var alertMessage = ""
    @Published var availableTypes: [String] = []
    @Published var availableModels: [String] = []
    @Published var availableOptions: [String] = []
    @Published var isLoadingProductInfo = false
    @Published var isUploading = false
    @Published var isEditing = false
    @Published var editingProductId: String? = nil

    init(
        fetchMetadataUseCase: FetchVehicleMetadataUseCase = VehicleDependencyContainer.shared.fetchVehicleMetadataUseCase(),
        createVehicleUseCase: CreateVehicleUseCase = VehicleDependencyContainer.shared.createVehicleUseCase(),
        updateVehicleUseCase: UpdateVehicleUseCase = VehicleDependencyContainer.shared.updateVehicleUseCase(),
        fetchVehicleDetailUseCase: FetchVehicleDetailUseCase = VehicleDependencyContainer.shared.fetchVehicleDetailUseCase(),
        imageUploadService: ImageUploadService = .shared
    ) {
        self.fetchMetadataUseCase = fetchMetadataUseCase
        self.createVehicleUseCase = createVehicleUseCase
        self.updateVehicleUseCase = updateVehicleUseCase
        self.fetchVehicleDetailUseCase = fetchVehicleDetailUseCase
        self.imageUploadService = imageUploadService
    }

    func loadProductInfo() async {
        isLoadingProductInfo = true
        defer { isLoadingProductInfo = false }
        do {
            let productInfo = try await fetchMetadataUseCase.execute()
            availableTypes = productInfo.types
            availableModels = productInfo.models
            availableOptions = productInfo.options
            vehicleOptions = availableOptions.map { VehicleOption(optionName: $0, isInclude: false) }
        } catch {
            let appError = ErrorMapper.map(error)
            AppLog.error("Load product info failed: \(appError.message)", category: "PRODUCT")
            // 기본값 사용
            availableTypes = ["모터홈", "픽업트럭", "SUV"]
            availableModels = ["현대 포레스트", "기아 쏘렌토", "Toyota Hilux"]
            availableOptions = ["샤워실", "화장실", "침대", "주방", "에어컨"]
            vehicleOptions = availableOptions.map { VehicleOption(optionName: $0, isInclude: false) }
        }
    }

    func loadForEdit(productId: String) async {
        isEditing = true
        editingProductId = productId
        do {
            let detail = try await fetchVehicleDetailUseCase.execute(productId: productId)
            apply(detail: detail)
        } catch {
            let appError = ErrorMapper.map(error)
            AppLog.error("Load detail for edit failed: \(appError.message)", category: "PRODUCT")
        }
    }

    private func apply(detail: VehicleDetailDomainModel) {
        title = detail.title
        generation = detail.generation.map { String($0) } ?? ""
        mileage = detail.mileage.map { String($0) } ?? ""
        vehicleType = detail.vehicleType
        vehicleModel = detail.vehicleModel
        price = detail.price.map { String($0) } ?? ""
        location = detail.location
        plateHash = detail.plateHash
        description = detail.description

        uploadedImageUrls = detail.images
        vehicleImages = detail.images.enumerated().compactMap { index, url in
            guard !url.isEmpty else { return nil }
            return VehicleImage(image: UIImage(), isMain: index == 0, uploadedUrl: url)
        }

        if availableOptions.isEmpty {
            availableOptions = detail.features
        }
        let included = Set(detail.features)
        vehicleOptions = availableOptions.map { VehicleOption(optionName: $0, isInclude: included.contains($0)) }
    }

    func validateAndSubmit() {
        errors = [:]
        var newErrors: [String: String] = [:]

        if title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { newErrors["title"] = "매물 제목을 입력하세요" }
        if generation.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { newErrors["generation"] = "연식을 입력하세요" }
        if mileage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { newErrors["mileage"] = "주행거리를 입력하세요" }
        if vehicleType.isEmpty { newErrors["vehicleType"] = "차량 종류를 선택해주세요" }
        if vehicleModel.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { newErrors["vehicleModel"] = "차량 브랜드/모델을 입력해주세요" }
        if price.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { newErrors["price"] = "판매 가격을 입력하세요" }
        if location.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { newErrors["location"] = "판매 지역을 입력하세요" }
        let trimmedPlate = plateHash.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedPlate.isEmpty {
            newErrors["plateHash"] = "차량 번호를 입력해주세요"
        } else if !Self.isValidKoreanPlate(trimmedPlate) {
            newErrors["plateHash"] = "올바른 번호판 형식을 입력하세요 (예: 123가4567)"
        }
        if description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty { newErrors["description"] = "상세 설명을 입력해주세요" }

        errors = newErrors
        if errors.isEmpty { Task { await submit() } }
    }

    private static func isValidKoreanPlate(_ plateNumber: String) -> Bool {
        let koreanPlateRegex = "^\\d{2,3}[가-힣]\\d{4}$"
        return plateNumber.range(of: koreanPlateRegex, options: .regularExpression) != nil
    }

    func submit() async {
        isSubmitting = true
        defer { isSubmitting = false }

        let cleanPrice = price.replacingOccurrences(of: ",", with: "")
        let cleanMileage = mileage.replacingOccurrences(of: ",", with: "")
        let mainImage = vehicleImages.first { $0.isMain }
        let mainUrl = mainImage?.uploadedUrl ?? ""
        let productUrls = uploadedImageUrls.filter { $0 != mainUrl }

        let draft = VehicleDraftDomainModel(
            generation: Int(generation) ?? 0,
            mileage: cleanMileage,
            vehicleType: vehicleType,
            vehicleModel: vehicleModel,
            price: cleanPrice,
            location: location,
            plateHash: plateHash,
            title: title,
            description: description,
            optionNames: vehicleOptions.map { $0.optionName },
            includedOptionNames: Set(vehicleOptions.filter { $0.isInclude }.map { $0.optionName }),
            mainImageURL: mainUrl,
            additionalImageURLs: productUrls
        )

        if isEditing, let productId = editingProductId {
            AppLog.info("Updating product (id: \(productId))", category: "PRODUCT")
            do {
                let result = try await updateVehicleUseCase.execute(productId: productId, draft: draft)
                handleResult(result, defaultMessage: "성공적으로 매물 정보가 수정되었습니다.")
            } catch {
                let appError = ErrorMapper.map(error)
                AppLog.error("Product update failed: \(appError.message)", category: "PRODUCT")
                alertMessage = appError.message
                showingErrorAlert = true
            }
        } else {
            AppLog.info("Creating product (title: \(title))", category: "PRODUCT")
            do {
                let result = try await createVehicleUseCase.execute(draft: draft)
                handleResult(result, defaultMessage: "등록이 완료되었습니다.")
            } catch {
                let appError = ErrorMapper.map(error)
                AppLog.error("Product creation failed: \(appError.message)", category: "PRODUCT")
                alertMessage = appError.message
                showingErrorAlert = true
            }
        }
    }

    func uploadImage(_ image: UIImage, for imageId: UUID) {
        isUploading = true
        imageUploadService.uploadImage(image) { [weak self] result in
            Task { @MainActor in
                guard let self else { return }
                self.isUploading = false

                switch result {
                case .success(let url):
                    self.errors["images"] = nil
                    if let index = self.vehicleImages.firstIndex(where: { $0.id == imageId }) {
                        self.vehicleImages[index].uploadedUrl = url

                        if self.vehicleImages[index].isMain {
                            self.uploadedImageUrls.removeAll { $0 == url }
                            self.uploadedImageUrls.insert(url, at: 0)
                        } else {
                            self.appendUploadedUrlIfNeeded(url)
                        }
                    } else {
                        self.appendUploadedUrlIfNeeded(url)
                    }
                case .failure(let error):
                    let appError = ErrorMapper.map(error)
                    self.errors["images"] = appError.message
                    self.vehicleImages.removeAll { $0.id == imageId }
                }
            }
        }
    }

    private func appendUploadedUrlIfNeeded(_ url: String) {
        guard !uploadedImageUrls.contains(url) else { return }
        uploadedImageUrls.append(url)
    }

    private func handleResult(_ result: VehicleRegistrationResultDomainModel, defaultMessage: String) {
        let succeeded = result.success || (200..<300).contains(result.statusCode)
        if succeeded {
            alertMessage = result.message.isEmpty ? defaultMessage : result.message
            showingSuccessAlert = true
        } else {
            alertMessage = result.message.isEmpty ? "요청이 실패했습니다." : result.message
            showingErrorAlert = true
        }
    }
}
