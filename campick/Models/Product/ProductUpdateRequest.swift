import Foundation

struct ProductUpdateRequest: Encodable {
    var title: String?
    var mileage: String?
    var vehicleType: String?
    var vehicleModel: String?
    var fuelType: String?
    var transmission: String?
    var generation: String?
    var price: String?
    var location: ProductLocationPayload?
    var plateHash: String?
    var description: String?
    var productImageUrl: [String]?
    var option: [ProductOptionPayload]?

    private enum CodingKeys: String, CodingKey {
        case title
        case mileage
        case vehicleType
        case vehicleModel
        case fuelType
        case transmission
        case generation
        case price
        case location
        case plateHash
        case description
        case productImageUrl
        case option
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(title, forKey: .title)
        try container.encodeIfPresent(mileage, forKey: .mileage)
        try container.encodeIfPresent(vehicleType, forKey: .vehicleType)
        try container.encodeIfPresent(vehicleModel, forKey: .vehicleModel)
        try container.encodeIfPresent(fuelType, forKey: .fuelType)
        try container.encodeIfPresent(transmission, forKey: .transmission)
        try container.encodeIfPresent(generation, forKey: .generation)
        try container.encodeIfPresent(price, forKey: .price)
        try container.encodeIfPresent(location, forKey: .location)
        try container.encodeIfPresent(plateHash, forKey: .plateHash)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encodeIfPresent(productImageUrl, forKey: .productImageUrl)
        try container.encodeIfPresent(option, forKey: .option)
    }
}

