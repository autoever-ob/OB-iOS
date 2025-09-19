//
//  HomeVehicleViewModel.swift
//  campick
//
//  Created by Admin on 9/19/25.
//

import Foundation


final class HomeVehicleViewModel: ObservableObject {
    @Published var vehicles: [Vehicle] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    func loadRecommendVehicles() {
        isLoading = true
        VehicleService.shared.getRecommendVehicles { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let data):
                    self?.vehicles = data
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

    // 가공된 속성 제공 (ex: UI에서 바로 쓰기 좋게)
    func yearText(for vehicle: Vehicle) -> String {
        "\(vehicle.year)년"
    }

    func mileageText(for vehicle: Vehicle) -> String {
        "\(vehicle.mileage)km"
    }

    func priceText(for vehicle: Vehicle) -> String {
        "\(vehicle.price)원"
    }
}
