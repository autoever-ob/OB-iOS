import Foundation

struct FetchVehicleRecommendationsUseCase {
    private let repository: VehicleRepository

    init(repository: VehicleRepository) {
        self.repository = repository
    }

    func execute() async throws -> [VehicleRecommendationDomainModel] {
        try await repository.fetchRecommendations()
    }
}

struct ToggleVehicleLikeUseCase {
    private let repository: VehicleRepository

    init(repository: VehicleRepository) {
        self.repository = repository
    }

    func execute(productId: String) async throws {
        try await repository.toggleLike(productId: productId)
    }
}

struct FetchVehicleListUseCase {
    private let repository: VehicleRepository

    init(repository: VehicleRepository) {
        self.repository = repository
    }

    func execute(query: VehicleSearchQueryDomainModel) async throws -> VehicleListPageDomainModel {
        try await repository.fetchVehicleList(query: query)
    }
}

struct FetchVehicleDetailUseCase {
    private let repository: VehicleRepository

    init(repository: VehicleRepository) {
        self.repository = repository
    }

    func execute(productId: String) async throws -> VehicleDetailDomainModel {
        try await repository.fetchVehicleDetail(productId: productId)
    }
}

struct UpdateVehicleStatusUseCase {
    private let repository: VehicleRepository

    init(repository: VehicleRepository) {
        self.repository = repository
    }

    func execute(productId: String, status: VehicleStatusDomain) async throws {
        try await repository.updateVehicleStatus(productId: productId, status: status)
    }
}

struct FetchFavoriteVehiclesUseCase {
    private let repository: VehicleRepository

    init(repository: VehicleRepository) {
        self.repository = repository
    }

    func execute(memberId: String, page: Int, size: Int) async throws -> VehicleFavoritePageDomainModel {
        try await repository.fetchFavorites(memberId: memberId, page: page, size: size)
    }
}

struct FetchVehicleMetadataUseCase {
    private let repository: VehicleRepository

    init(repository: VehicleRepository) {
        self.repository = repository
    }

    func execute() async throws -> VehicleMetadataDomainModel {
        try await repository.fetchMetadata()
    }
}

struct CreateVehicleUseCase {
    private let repository: VehicleRepository

    init(repository: VehicleRepository) {
        self.repository = repository
    }

    func execute(draft: VehicleDraftDomainModel) async throws -> VehicleRegistrationResultDomainModel {
        try await repository.createVehicle(draft)
    }
}

struct UpdateVehicleUseCase {
    private let repository: VehicleRepository

    init(repository: VehicleRepository) {
        self.repository = repository
    }

    func execute(productId: String, draft: VehicleDraftDomainModel) async throws -> VehicleRegistrationResultDomainModel {
        try await repository.updateVehicle(productId: productId, draft: draft)
    }
}
