//
//  CarRepositoryProtocol.swift
//  campick
//
//  Created by Kihwan Jo on 9/16/25.
//


protocol CarRepositoryProtocol {
    func fetchCars() async throws -> [Car]
}
