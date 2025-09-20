//
//  HomeVehicleViewModel.swift
//  campick
//
//  Created by Admin on 9/19/25.
//

import Foundation


final class HomeVehicleViewModel: ObservableObject {
    @Published var vehicles: [RecommendedVehicle] = []
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

}
