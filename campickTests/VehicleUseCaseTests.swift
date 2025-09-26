import XCTest
@testable import campick

final class VehicleUseCaseTests: XCTestCase {

    func testToggleLikeDelegatesToRepository() async throws {
        let repository = VehicleRepositoryMock()
        let useCase = ToggleVehicleLikeUseCase(repository: repository)

        try await useCase.execute(productId: "123")

        XCTAssertEqual(repository.toggleLikeCallCount, 1)
        XCTAssertEqual(repository.lastToggleId, "123")
    }

    func testFetchVehicleDetailReturnsRepositoryValue() async throws {
        let repository = VehicleRepositoryMock()
        let expected = VehicleDetailDomainModel.sample(id: "321")
        repository.fetchVehicleDetailResult = expected
        let useCase = FetchVehicleDetailUseCase(repository: repository)

        let detail = try await useCase.execute(productId: "321")

        XCTAssertEqual(detail.id, expected.id)
        XCTAssertEqual(detail.title, expected.title)
        XCTAssertEqual(detail.seller.nickname, expected.seller.nickname)
    }

    func testUpdateVehicleStatusPropagatesRepositoryError() async {
        let repository = VehicleRepositoryMock()
        repository.updateVehicleStatusError = MockError.stub
        let useCase = UpdateVehicleStatusUseCase(repository: repository)

        await XCTAssertThrowsErrorAsync(try await useCase.execute(productId: "777", status: .sold))

        XCTAssertEqual(repository.updateVehicleStatusCallCount, 1)
        XCTAssertEqual(repository.lastToggleId, "777")
        XCTAssertEqual(repository.updateStatusArguments.first?.status, .sold)
    }
}

// MARK: - Test Doubles

private final class VehicleRepositoryMock: VehicleRepository {
    var recommendations: [VehicleRecommendationDomainModel] = []
    var toggleLikeCallCount = 0
    var lastToggleId: String?

    var fetchVehicleListResult = VehicleListPageDomainModel.sample()
    var fetchVehicleDetailResult: VehicleDetailDomainModel?
    var fetchVehicleDetailError: Error?

    var updateVehicleStatusCallCount = 0
    var updateStatusArguments: [(id: String, status: VehicleStatusDomain)] = []
    var updateVehicleStatusError: Error?

    var favoritesResult = VehicleFavoritePageDomainModel(items: [], totalElements: 0)
    var metadataResult = VehicleMetadataDomainModel(types: [], models: [], options: [])
    var createVehicleResult = VehicleRegistrationResultDomainModel(success: true, statusCode: 201, message: "ok", productId: 1)
    var updateVehicleResult = VehicleRegistrationResultDomainModel(success: true, statusCode: 200, message: "ok", productId: 1)

    func fetchRecommendations() async throws -> [VehicleRecommendationDomainModel] {
        recommendations
    }

    func toggleLike(productId: String) async throws {
        toggleLikeCallCount += 1
        lastToggleId = productId
    }

    func fetchVehicleList(query: VehicleSearchQueryDomainModel) async throws -> VehicleListPageDomainModel {
        fetchVehicleListResult
    }

    func fetchVehicleDetail(productId: String) async throws -> VehicleDetailDomainModel {
        if let fetchVehicleDetailError { throw fetchVehicleDetailError }
        guard let fetchVehicleDetailResult else { throw MockError.unconfigured }
        lastToggleId = productId
        return fetchVehicleDetailResult
    }

    func updateVehicleStatus(productId: String, status: VehicleStatusDomain) async throws {
        updateVehicleStatusCallCount += 1
        updateStatusArguments.append((productId, status))
        lastToggleId = productId
        if let updateVehicleStatusError { throw updateVehicleStatusError }
    }

    func fetchFavorites(memberId: String, page: Int, size: Int) async throws -> VehicleFavoritePageDomainModel {
        favoritesResult
    }

    func fetchMetadata() async throws -> VehicleMetadataDomainModel {
        metadataResult
    }

    func createVehicle(_ draft: VehicleDraftDomainModel) async throws -> VehicleRegistrationResultDomainModel {
        createVehicleResult
    }

    func updateVehicle(productId: String, draft: VehicleDraftDomainModel) async throws -> VehicleRegistrationResultDomainModel {
        updateVehicleResult
    }
}

// MARK: - Samples & Helpers

private enum MockError: Error { case unconfigured, stub }

private extension VehicleListPageDomainModel {
    static func sample() -> VehicleListPageDomainModel {
        let vehicle = VehicleSummaryDomainModel(
            id: "100",
            title: "테스트 차량",
            price: 1000,
            mileage: 10000,
            year: 2023,
            vehicleType: "SUV",
            location: "서울",
            thumbnailURL: URL(string: "https://example.com/thumb.png"),
            isLiked: false,
            likeCount: 0,
            status: .active
        )
        return VehicleListPageDomainModel(items: [vehicle], totalElements: 1, totalPages: 1, currentPage: 0, isLast: true)
    }
}

private extension VehicleDetailDomainModel {
    static func sample(id: String) -> VehicleDetailDomainModel {
        let seller = VehicleSellerDomainModel(
            id: "seller-\(id)",
            name: "캠픽",
            nickname: "딜러-\(id)",
            phoneNumber: "010-1111-2222",
            email: "dealer@example.com",
            avatarURL: "https://example.com/avatar.png",
            totalListings: 5,
            totalSales: 3,
            isDealer: true
        )
        return VehicleDetailDomainModel(
            id: id,
            title: "테스트 차량 상세",
            price: 1000,
            generation: 2,
            mileage: 15000,
            vehicleType: "SUV",
            vehicleModel: "모델X",
            location: "서울시",
            description: "깨끗하게 관리된 차량",
            images: ["https://example.com/1.png"],
            features: ["네비게이션"],
            status: .active,
            isLiked: true,
            likeCount: 12,
            seller: seller,
            fuelType: "전기",
            transmission: "오토",
            plateHash: "12가3456"
        )
    }
}

private extension XCTestCase {
    func XCTAssertThrowsErrorAsync(_ expression: @autoclosure () async throws -> Void, file: StaticString = #filePath, line: UInt = #line) async {
        do {
            try await expression()
            XCTFail("Expected error to be thrown", file: file, line: line)
        } catch {
            // expected
        }
    }
}
