import Foundation

/// 매물 목록 조회 시 개별 아이템 DTO
struct ProductItemDTO: Decodable {
    let productId: Int
    let title: String
    let price: String
    let mileage: String
    let vehicleType: String
    let vehicleModel: String
    let fuelType: String
    let transmission: String
    let location: ProductLocationDTO
    let createdAt: String
    let thumbNail: String
    let isLiked: Bool
    let likeCount: Int
    let status: String
}

struct ProductLocationDTO: Codable {
    let province: String
    let city: String
}

struct ProductOptionDTO: Codable {
    let optionName: String
    let isInclude: Bool
}

struct ProductSellerDTO: Decodable {
    let nickName: String
    let role: String
    let rating: Double
    let sellingCount: Int
    let completeCount: Int
    let userId: Int
}
