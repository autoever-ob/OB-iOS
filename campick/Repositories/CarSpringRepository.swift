//
//  CarSpringRepository.swift
//  campick
//
//  Created by Kihwan Jo on 9/16/25.
//

import Foundation

class CarSpringRepository: CarRepositoryProtocol {
    private let urlSession = URLSession.shared
    private let baseURL = URL(string: "http://192.168.201.15:8080")!

    func fetchCars() async throws -> [Car] {
        let url = baseURL.appendingPathComponent("cars")
        let (data, _) = try await urlSession.data(from: url)
        let carsSpring = try JSONDecoder().decode([CarSpring].self, from: data)
        return carsSpring.map { $0.toDomain() }
    }
}
