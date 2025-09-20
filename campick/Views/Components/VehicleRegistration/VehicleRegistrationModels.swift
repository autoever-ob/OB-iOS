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
    var uploadedUrl: String? = nil
}


struct VehicleOption: Identifiable, Codable {
    let id = UUID()
    var optionName: String
    var isInclude: Bool

    enum CodingKeys: String, CodingKey {
        case optionName, isInclude
    }
}


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