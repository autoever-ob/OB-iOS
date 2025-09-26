import Foundation

final class VehicleRepositoryImpl: VehicleRepository {
    private let remote: VehicleRemoteDataSource

    init(remote: VehicleRemoteDataSource = DefaultVehicleRemoteDataSource()) {
        self.remote = remote
    }

    func fetchRecommendations() async throws -> [VehicleRecommendationDomainModel] {
        let response = try await remote.fetchRecommendations()
        return VehicleDataMapper.mapRecommendation(response)
    }

    func toggleLike(productId: String) async throws {
        try await remote.toggleLike(productId: productId)
    }

    func fetchVehicleList(query: VehicleSearchQueryDomainModel) async throws -> VehicleListPageDomainModel {
        let filter = ProductFilterRequest(
            mileageFrom: query.mileageFrom,
            mileageTo: query.mileageTo,
            costFrom: query.costFrom,
            costTo: query.costTo,
            generationFrom: query.generationFrom,
            generationTo: query.generationTo,
            types: query.types
        )
        let sort = mapSort(query.sort)
        let page = try await remote.fetchProducts(page: query.page, size: query.size, filter: filter, sort: sort)
        return VehicleDataMapper.mapSummaryPage(page)
    }

    func fetchVehicleDetail(productId: String) async throws -> VehicleDetailDomainModel {
        let dto = try await remote.fetchProductDetail(productId: productId)
        return VehicleDataMapper.mapDetail(dto)
    }

    func updateVehicleStatus(productId: String, status: VehicleStatusDomain) async throws {
        let apiStatus = mapStatus(status)
        let response = try await remote.updateProductStatus(productId: productId, status: apiStatus)
        let success = (response.success ?? false) || (200..<300).contains(response.status ?? 0)
        if !success {
            throw NSError(
                domain: "VehicleStatusUpdate",
                code: response.status ?? -1,
                userInfo: [NSLocalizedDescriptionKey: response.message ?? "상태 변경에 실패했습니다."]
            )
        }
    }

    func fetchFavorites(memberId: String, page: Int, size: Int) async throws -> VehicleFavoritePageDomainModel {
        let response = try await remote.fetchFavorites(memberId: memberId, page: page, size: size)
        return VehicleDataMapper.mapFavoritePage(response)
    }

    func fetchMetadata() async throws -> VehicleMetadataDomainModel {
        let response = try await remote.fetchProductInfo()
        return VehicleDataMapper.mapMetadata(response)
    }

    func createVehicle(_ draft: VehicleDraftDomainModel) async throws -> VehicleRegistrationResultDomainModel {
        let request = mapDraft(draft)
        let response = try await remote.createProduct(request)
        return VehicleDataMapper.mapRegistrationResult(response)
    }

    func updateVehicle(productId: String, draft: VehicleDraftDomainModel) async throws -> VehicleRegistrationResultDomainModel {
        let request = mapDraft(draft)
        let response = try await remote.updateProduct(productId: productId, request: request)
        return VehicleDataMapper.mapRegistrationResult(response)
    }

    // MARK: - Helpers
    private func mapDraft(_ draft: VehicleDraftDomainModel) -> VehicleRegistrationRequest {
        let options = draft.optionNames.map { name in
            VehicleOption(optionName: name, isInclude: draft.includedOptionNames.contains(name))
        }
        return VehicleRegistrationRequest(
            generation: draft.generation,
            mileage: draft.mileage,
            vehicleType: draft.vehicleType,
            vehicleModel: draft.vehicleModel,
            price: draft.price,
            location: draft.location,
            plateHash: draft.plateHash,
            title: draft.title,
            description: draft.description,
            productImageUrl: draft.additionalImageURLs,
            option: options,
            mainProductImageUrl: draft.mainImageURL
        )
    }

    private func mapSort(_ option: VehicleSortOptionDomain?) -> ProductSort? {
        guard let option else { return nil }
        switch option {
        case .createdAtDesc: return .createdAtDesc
        case .costAsc: return .costAsc
        case .costDesc: return .costDesc
        case .mileageAsc: return .mileageAsc
        case .generationDesc: return .generationDesc
        }
    }

    private func mapStatus(_ status: VehicleStatusDomain) -> VehicleStatus {
        switch status {
        case .active: return .active
        case .reserved: return .reserved
        case .sold: return .sold
        }
    }
}
