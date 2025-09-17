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
    VehicleType(value: "motorhome", label: "모터홈", iconName: "bus"),
    VehicleType(value: "trailer", label: "트레일러", iconName: "truck.box"),
    VehicleType(value: "pickup", label: "픽업캠퍼", iconName: "car"),
    VehicleType(value: "van", label: "캠핑밴", iconName: "car.side"),
]