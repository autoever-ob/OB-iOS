//
//  CarViewModel.swift
//  campick
//
//  Created by Kihwan Jo on 9/16/25.
//
import SwiftUI

@MainActor
class CarViewModel: ObservableObject {
    @Published var cars: [Car] = []
    
    private let repository: CarRepositoryProtocol
    
    init(repository: CarRepositoryProtocol = CarSpringRepository()) {
//    init(repository: CarRepositoryProtocol = CarFiebaseRepository()) {
        self.repository = repository
        Task {
            await fetchCars()
        }
    }
    
    func fetchCars() async {
        let cars = try? await repository.fetchCars()
        self.cars = cars ?? []
    }
}
