import Foundation

final class VehicleDependencyContainer {
    static let shared = VehicleDependencyContainer()

    private let repository: VehicleRepository

    private init(repository: VehicleRepository = VehicleRepositoryImpl()) {
        self.repository = repository
    }

    func fetchRecommendationsUseCase() -> FetchVehicleRecommendationsUseCase {
        FetchVehicleRecommendationsUseCase(repository: repository)
    }

    func toggleLikeUseCase() -> ToggleVehicleLikeUseCase {
        ToggleVehicleLikeUseCase(repository: repository)
    }

    func fetchVehicleListUseCase() -> FetchVehicleListUseCase {
        FetchVehicleListUseCase(repository: repository)
    }

    func fetchVehicleDetailUseCase() -> FetchVehicleDetailUseCase {
        FetchVehicleDetailUseCase(repository: repository)
    }

    func updateVehicleStatusUseCase() -> UpdateVehicleStatusUseCase {
        UpdateVehicleStatusUseCase(repository: repository)
    }

    func fetchFavoriteVehiclesUseCase() -> FetchFavoriteVehiclesUseCase {
        FetchFavoriteVehiclesUseCase(repository: repository)
    }

    func fetchVehicleMetadataUseCase() -> FetchVehicleMetadataUseCase {
        FetchVehicleMetadataUseCase(repository: repository)
    }

    func createVehicleUseCase() -> CreateVehicleUseCase {
        CreateVehicleUseCase(repository: repository)
    }

    func updateVehicleUseCase() -> UpdateVehicleUseCase {
        UpdateVehicleUseCase(repository: repository)
    }
}
