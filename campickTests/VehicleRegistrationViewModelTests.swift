import XCTest
import UIKit
@testable import campick

@MainActor
final class VehicleRegistrationViewModelTests: XCTestCase {

    func testUploadImageSuccessUpdatesUrlsAndClearsError() async {
        let imageService = ImageUploadServiceMock(expectedResult: .success("https://example.com/main.png"))
        let repository = VehicleRepositoryDummy()
        let viewModel = VehicleRegistrationViewModel(
            fetchMetadataUseCase: FetchVehicleMetadataUseCase(repository: repository),
            createVehicleUseCase: CreateVehicleUseCase(repository: repository),
            updateVehicleUseCase: UpdateVehicleUseCase(repository: repository),
            fetchVehicleDetailUseCase: FetchVehicleDetailUseCase(repository: repository),
            imageUploadService: imageService
        )

        let imageId = UUID()
        viewModel.vehicleImages = [VehicleImage(id: imageId, image: UIImage(), isMain: true, uploadedUrl: nil)]
        viewModel.errors["images"] = "에러"

        viewModel.uploadImage(UIImage(), for: imageId)
        await flushMainQueue()

        XCTAssertEqual(imageService.uploadCallCount, 1)
        XCTAssertNil(viewModel.errors["images"])
        XCTAssertEqual(viewModel.vehicleImages.first?.uploadedUrl, "https://example.com/main.png")
        XCTAssertEqual(viewModel.uploadedImageUrls.first, "https://example.com/main.png")
        XCTAssertFalse(viewModel.isUploading)
    }

    func testUploadImageFailureRemovesImageAndSetsError() async {
        let imageService = ImageUploadServiceMock(expectedResult: .failure(MockError.fail))
        let repository = VehicleRepositoryDummy()
        let viewModel = VehicleRegistrationViewModel(
            fetchMetadataUseCase: FetchVehicleMetadataUseCase(repository: repository),
            createVehicleUseCase: CreateVehicleUseCase(repository: repository),
            updateVehicleUseCase: UpdateVehicleUseCase(repository: repository),
            fetchVehicleDetailUseCase: FetchVehicleDetailUseCase(repository: repository),
            imageUploadService: imageService
        )

        let imageId = UUID()
        viewModel.vehicleImages = [VehicleImage(id: imageId, image: UIImage(), isMain: false, uploadedUrl: nil)]

        viewModel.uploadImage(UIImage(), for: imageId)
        await flushMainQueue()

        XCTAssertTrue(viewModel.vehicleImages.isEmpty)
        XCTAssertNotNil(viewModel.errors["images"])
        XCTAssertFalse(viewModel.isUploading)
    }

    func testSubmitWithValidFormCreatesVehicle() async {
        let repository = VehicleRepositoryDummy()
        repository.createResult = VehicleRegistrationResultDomainModel(success: true, statusCode: 201, message: "", productId: 1)
        let imageService = ImageUploadServiceMock(expectedResult: .success("https://example.com/main.png"))

        let viewModel = VehicleRegistrationViewModel(
            fetchMetadataUseCase: FetchVehicleMetadataUseCase(repository: repository),
            createVehicleUseCase: CreateVehicleUseCase(repository: repository),
            updateVehicleUseCase: UpdateVehicleUseCase(repository: repository),
            fetchVehicleDetailUseCase: FetchVehicleDetailUseCase(repository: repository),
            imageUploadService: imageService
        )

        viewModel.title = "테스트 차량"
        viewModel.generation = "2022"
        viewModel.mileage = "12000"
        viewModel.vehicleType = "SUV"
        viewModel.vehicleModel = "테스트 모델"
        viewModel.price = "35000000"
        viewModel.location = "서울"
        viewModel.plateHash = "12가3456"
        viewModel.description = "좋은 차량"
        viewModel.vehicleOptions = [VehicleOption(optionName: "옵션", isInclude: true)]

        let imageId = UUID()
        viewModel.vehicleImages = [VehicleImage(id: imageId, image: UIImage(), isMain: true, uploadedUrl: "https://example.com/main.png")]
        viewModel.uploadedImageUrls = ["https://example.com/main.png"]

        await viewModel.submit()

        XCTAssertEqual(repository.createCallCount, 1)
        XCTAssertTrue(viewModel.showingSuccessAlert)
        XCTAssertFalse(viewModel.isSubmitting)
    }

    // MARK: - Helpers

    private func flushMainQueue() async {
        await Task.yield()
        try? await Task.sleep(nanoseconds: 50_000_000) // 0.05s
    }
}

// MARK: - Test Doubles

private enum MockError: Error { case fail }

private final class ImageUploadServiceMock: ImageUploadServicing {
    let expectedResult: Result<String, Error>
    private(set) var uploadCallCount = 0

    init(expectedResult: Result<String, Error>) {
        self.expectedResult = expectedResult
    }

    func uploadImage(_ image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        uploadCallCount += 1
        completion(expectedResult)
    }
}

private final class VehicleRepositoryDummy: VehicleRepository {
    var createResult = VehicleRegistrationResultDomainModel(success: false, statusCode: 500, message: "", productId: nil)
    private(set) var createCallCount = 0

    func fetchRecommendations() async throws -> [VehicleRecommendationDomainModel] { [] }
    func toggleLike(productId: String) async throws {}
    func fetchVehicleList(query: VehicleSearchQueryDomainModel) async throws -> VehicleListPageDomainModel {
        VehicleListPageDomainModel(items: [], totalElements: 0, totalPages: 0, currentPage: 0, isLast: true)
    }
    func fetchVehicleDetail(productId: String) async throws -> VehicleDetailDomainModel {
        throw MockError.fail
    }
    func updateVehicleStatus(productId: String, status: VehicleStatusDomain) async throws {}
    func fetchFavorites(memberId: String, page: Int, size: Int) async throws -> VehicleFavoritePageDomainModel {
        VehicleFavoritePageDomainModel(items: [], totalElements: 0)
    }
    func fetchMetadata() async throws -> VehicleMetadataDomainModel {
        VehicleMetadataDomainModel(types: [], models: [], options: [])
    }
    func createVehicle(_ draft: VehicleDraftDomainModel) async throws -> VehicleRegistrationResultDomainModel {
        createCallCount += 1
        return createResult
    }
    func updateVehicle(productId: String, draft: VehicleDraftDomainModel) async throws -> VehicleRegistrationResultDomainModel {
        createResult
    }
}
