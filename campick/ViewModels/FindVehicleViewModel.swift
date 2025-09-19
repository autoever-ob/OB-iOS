//
//  FindVehicleViewModel.swift
//  campick
//
//  Created by Assistant on 9/19/25.
//

import Foundation
import SwiftUI

@MainActor
final class FindVehicleViewModel: ObservableObject {
    // Search / UI state
    @Published var query: String = ""
    @Published var showingFilter: Bool = false
    @Published var showingSortView: Bool = false
    @Published var filterOptions: FilterOptions = .init()
    @Published var selectedSort: SortOption = .recentlyAdded

    // Data
    @Published var vehicles: [Vehicle] = []

    func onSubmitQuery() {
        fetchVehicles()
    }

    func onChangeFilter() {
        fetchVehicles()
    }

    func onChangeSort() {
        fetchVehicles()
    }

    func onAppear() {
        fetchVehicles()
    }

    func fetchVehicles() {
        // TODO: Replace with API integration
        // Temporary mock data to keep UI functional
        let mock: [Vehicle] = [
            Vehicle(id: "1", imageName: "testImage3", thumbnailURL: nil, title: "모터홈 A", price: "2,900만원", year: "2021년", mileage: "8,000km", fuelType: "가솔린", transmission: "자동", location: "서울", status: .active, postedDate: "1일 전", isOnSale: true, isFavorite: false),
            Vehicle(id: "2", imageName: "testImage3", thumbnailURL: nil, title: "트레일러 B", price: "3,850만원", year: "2022년", mileage: "12,000km", fuelType: "디젤", transmission: "수동", location: "부산", status: .active, postedDate: "2일 전", isOnSale: true, isFavorite: false),
            Vehicle(id: "3", imageName: "testImage3", thumbnailURL: nil, title: "픽업캠퍼 C", price: "4,500만원", year: "2023년", mileage: "25,000km", fuelType: "하이브리드", transmission: "자동", location: "인천", status: .active, postedDate: "3일 전", isOnSale: true, isFavorite: false),
            Vehicle(id: "4", imageName: "testImage3", thumbnailURL: nil, title: "캠핑밴 D", price: "5,200만원", year: "2024년", mileage: "40,000km", fuelType: "전기", transmission: "수동", location: "대구", status: .active, postedDate: "4일 전", isOnSale: true, isFavorite: false)
        ]

        // Simple client-side filtering by query (title/location)
        let q = query.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        var filtered = mock
        if !q.isEmpty {
            filtered = filtered.filter { v in
                v.title.lowercased().contains(q) || v.location.lowercased().contains(q)
            }
        }

        // TODO: apply filterOptions

        // Simple sort examples
        switch selectedSort {
        case .recentlyAdded:
            vehicles = filtered // mock already recent
        case .lowPrice:
            vehicles = filtered.sorted { priceValue($0.price) < priceValue($1.price) }
        case .highPrice:
            vehicles = filtered.sorted { priceValue($0.price) > priceValue($1.price) }
        case .lowMileage:
            vehicles = filtered.sorted { mileageValue($0.mileage) < mileageValue($1.mileage) }
        case .newestYear:
            vehicles = filtered.sorted { yearValue($0.year) > yearValue($1.year) }
        }
    }

    // MARK: - Parsing helpers
    private func digits(from s: String) -> Int {
        let n = s.filter { $0.isNumber }
        return Int(n) ?? 0
    }
    private func priceValue(_ s: String) -> Int { digits(from: s) }
    private func mileageValue(_ s: String) -> Int { digits(from: s) }
    private func yearValue(_ s: String) -> Int { digits(from: s) }
}
