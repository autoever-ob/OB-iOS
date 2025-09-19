//
//  VehicleCardViewModel.swift
//  campick
//
//  Created by Assistant on 9/19/25.
//

import Foundation
import SwiftUI

@MainActor
final class VehicleCardViewModel: ObservableObject {
    // Display properties
    let imageName: String?
    let thumbnailURL: URL?
    let title: String
    let price: String
    let year: String
    let mileage: String
    let fuelType: String
    let transmission: String
    let location: String
    let isOnSale: Bool

    // Local UI state
    @Published var isFavorite: Bool

    // Initializers
    init(vehicle: Vehicle) {
        self.imageName = vehicle.imageName
        self.thumbnailURL = vehicle.thumbnailURL
        self.title = vehicle.title
        self.price = vehicle.price
        self.year = vehicle.year
        self.mileage = vehicle.mileage
        self.fuelType = vehicle.fuelType
        self.transmission = vehicle.transmission
        self.location = vehicle.location
        self.isOnSale = vehicle.isOnSale
        self.isFavorite = vehicle.isFavorite
    }

    init(
        title: String,
        price: String,
        year: String = "-",
        mileage: String = "-",
        fuelType: String = "-",
        transmission: String = "-",
        location: String,
        imageName: String? = nil,
        thumbnailURL: URL? = nil,
        isOnSale: Bool = true,
        isFavorite: Bool = false
    ) {
        self.imageName = imageName
        self.thumbnailURL = thumbnailURL
        self.title = title
        self.price = price
        self.year = year
        self.mileage = mileage
        self.fuelType = fuelType
        self.transmission = transmission
        self.location = location
        self.isOnSale = isOnSale
        self.isFavorite = isFavorite
    }

    func toggleFavorite() {
        isFavorite.toggle()
        // TODO: Hook to persistence or API if needed
    }
}

