//
//  VehicleRegistrationModels.swift
//  campick
//
//  Created by 김호집 on 9/17/25.
//

import SwiftUI

struct VehicleImage: Identifiable, Hashable {
    let id = UUID()
    var image: UIImage
    var isMain: Bool = false
}

struct VehicleType {
    let value: String
    let label: String
    let iconName: String
}

let vehicleTypes = [
    VehicleType(value: "MOTOR_HOME", label: "모터홈", iconName: "bus"),
    VehicleType(value: "TRAILER", label: "트레일러", iconName: "truck.box"),
    VehicleType(value: "TRUCK_CAMPER", label: "픽업캠퍼", iconName: "car"),
    VehicleType(value: "CARAVAN", label: "캠핑밴", iconName: "car.side"),
    VehicleType(value: "ETC", label: "기타", iconName: "car.side.fill"),
]

struct VehicleOption: Identifiable, Codable {
    let id = UUID()
    var optionName: String
    var isInclude: Bool

    enum CodingKeys: String, CodingKey {
        case optionName, isInclude
    }
}

let defaultVehicleOptions = [
    VehicleOption(optionName: "에어컨", isInclude: false),
    VehicleOption(optionName: "난방", isInclude: false),
    VehicleOption(optionName: "냉장고", isInclude: false),
    VehicleOption(optionName: "전자레인지", isInclude: false),
    VehicleOption(optionName: "화장실", isInclude: false),
    VehicleOption(optionName: "샤워실", isInclude: false),
    VehicleOption(optionName: "침대", isInclude: false),
    VehicleOption(optionName: "TV", isInclude: false),
]

// API Models
struct VehicleRegistrationRequest: Codable {
    let generation: String
    let mileage: String
    let vehicleType: String
    let vehicleModel: String
    let price: String
    let location: String
    let plateHash: String
    let title: String
    let description: String
    let productImageUrl: [String]
    let option: [VehicleOption]
    let mainProductImageUrl: String
}

struct APIResponse<T: Codable>: Codable {
    let status: Int
    let success: Bool
    let message: String
    let data: T?
}