//
//  VehicleResponse.swift
//  campick
//
//  Created by Admin on 9/20/25.
//

import Foundation

struct VehicleResponse: Decodable {
    let newVehicle: RecommendedVehicle
    let hotVehicle: RecommendedVehicle
}
