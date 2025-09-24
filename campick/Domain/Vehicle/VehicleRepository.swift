import Foundation

protocol VehicleRepository {
    func fetchRecommendations() async throws -> [VehicleRecommendationDomainModel]
    func toggleLike(productId: String) async throws
    func fetchVehicleList(query: VehicleSearchQueryDomainModel) async throws -> VehicleListPageDomainModel
    func fetchVehicleDetail(productId: String) async throws -> VehicleDetailDomainModel
    func updateVehicleStatus(productId: String, status: VehicleStatusDomain) async throws
    func fetchFavorites(memberId: String, page: Int, size: Int) async throws -> VehicleFavoritePageDomainModel
    func fetchMetadata() async throws -> VehicleMetadataDomainModel
    func createVehicle(_ draft: VehicleDraftDomainModel) async throws -> VehicleRegistrationResultDomainModel
    func updateVehicle(productId: String, draft: VehicleDraftDomainModel) async throws -> VehicleRegistrationResultDomainModel
}
