import Foundation

// 매물 등록 요청 DTO
struct ProductCreateRequest: Encodable {
    let title: String
    let mileage: String
    let vehicleType: String
    let vehicleModel: String
    let fuelType: String
    let transmission: String
    let generation: String
    let price: String
    let location: ProductLocationPayload
    let plateHash: String
    let description: String
    let productImageUrl: [String]
    let option: [ProductOptionPayload]
}

struct ProductLocationPayload: Codable {
    let province: String
    let city: String
}

struct ProductOptionPayload: Codable {
    let optionName: String
    let isInclude: Bool
}

