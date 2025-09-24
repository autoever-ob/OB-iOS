import Foundation

// MARK: - Domain Models

enum VehicleStatusDomain: String {
    case active
    case reserved
    case sold
}

struct VehicleSummaryDomainModel: Identifiable {
    let id: String
    let title: String
    let price: Int?
    let mileage: Int?
    let year: Int?
    let vehicleType: String?
    let location: String
    let thumbnailURL: URL?
    let isLiked: Bool
    let likeCount: Int
    let status: VehicleStatusDomain
}

struct VehicleSellerDomainModel {
    let id: String
    let name: String
    let nickname: String
    let phoneNumber: String
    let email: String
    let avatarURL: String
    let totalListings: Int
    let totalSales: Int
    let isDealer: Bool
}

struct VehicleDetailDomainModel {
    let id: String
    let title: String
    let price: Int?
    let generation: Int?
    let mileage: Int?
    let vehicleType: String
    let vehicleModel: String
    let location: String
    let description: String
    let images: [String]
    let features: [String]
    let status: VehicleStatusDomain
    let isLiked: Bool
    let likeCount: Int
    let seller: VehicleSellerDomainModel
    let fuelType: String
    let transmission: String
    let plateHash: String
}

struct VehicleRecommendationDomainModel: Identifiable {
    let id: String
    let productId: String
    let title: String
    let price: Int?
    let generation: Int?
    let mileage: Int?
    let thumbnailURL: URL?
    let isLiked: Bool
    let likeCount: Int
    let location: String
    let highlightTag: String
}

struct VehicleMetadataDomainModel {
    let types: [String]
    let models: [String]
    let options: [String]
}

struct VehicleDraftDomainModel {
    let generation: Int
    let mileage: String
    let vehicleType: String
    let vehicleModel: String
    let price: String
    let location: String
    let plateHash: String
    let title: String
    let description: String
    let optionNames: [String]
    let includedOptionNames: Set<String>
    let mainImageURL: String
    let additionalImageURLs: [String]
}

struct VehicleListPageDomainModel {
    let items: [VehicleSummaryDomainModel]
    let totalElements: Int
    let totalPages: Int
    let currentPage: Int
    let isLast: Bool
}

struct VehicleFavoritePageDomainModel {
    let items: [VehicleSummaryDomainModel]
    let totalElements: Int
}

struct VehicleSearchQueryDomainModel {
    let page: Int
    let size: Int
    let mileageFrom: Int?
    let mileageTo: Int?
    let costFrom: Int?
    let costTo: Int?
    let generationFrom: Int?
    let generationTo: Int?
    let types: [String]?
    let sort: VehicleSortOptionDomain?
}

enum VehicleSortOptionDomain {
    case createdAtDesc
    case costAsc
    case costDesc
    case mileageAsc
    case generationDesc
}

struct VehicleRegistrationResultDomainModel {
    let success: Bool
    let statusCode: Int
    let message: String
    let productId: Int?
}
