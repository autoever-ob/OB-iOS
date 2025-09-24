//
//  FindVehicleViewModel.swift
//  campick
//
//  Created by Assistant on 9/19/25.
//

import Foundation
import SwiftUI
import UIKit

@MainActor
final class FindVehicleViewModel: ObservableObject {
    private let fetchVehicleListUseCase: FetchVehicleListUseCase
    // Search / UI state
    @Published var query: String = ""
    @Published var showingFilter: Bool = false
    @Published var showingSortView: Bool = false
    @Published var filterOptions: FilterOptions = .init()
    @Published var selectedSort: SortOption = .recentlyAdded

    // Data
    @Published var vehicles: [Vehicle] = []
    @Published var isLoading: Bool = false
    @Published var isPreloadingImages: Bool = false

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

    init(fetchVehicleListUseCase: FetchVehicleListUseCase = VehicleDependencyContainer.shared.fetchVehicleListUseCase()) {
        self.fetchVehicleListUseCase = fetchVehicleListUseCase
    }

    func fetchVehicles() {
        Task {
            isLoading = true
            do {
                let allowedTypes = Set(VehicleType.allCases) // 서버 허용 값
                let selectedTypes = vmSafeTypes()
                let validTypes = Array(selectedTypes.intersection(allowedTypes))

                let query = VehicleSearchQueryDomainModel(
                    page: 0,
                    size: 30,
                    mileageFrom: Int(filterOptions.mileageRange.lowerBound),
                    mileageTo: Int(filterOptions.mileageRange.upperBound),
                    costFrom: Int(filterOptions.priceRange.lowerBound) * 10_000,
                    costTo: Int(filterOptions.priceRange.upperBound) * 10_000,
                    generationFrom: Int(filterOptions.yearRange.lowerBound),
                    generationTo: Int(filterOptions.yearRange.upperBound),
                    types: validTypes.isEmpty ? nil : validTypes.map { $0.apiValue },
                    sort: mapSort(selectedSort)
                )

                let page = try await fetchVehicleListUseCase.execute(query: query)
                let mapped = page.items.map(mapToVehicle)
                vehicles = mapped

                // Preload vehicle images
                await preloadVehicleImages(mapped)
            } catch {
                // 네트워크 실패 시 현재 리스트 유지 또는 비우기 선택
                vehicles = []
            }
            isLoading = false
        }
    }

    private func vmSafeTypes() -> Set<VehicleType> {
        return filterOptions.selectedVehicleTypes
    }

    private func mapSort(_ option: SortOption) -> VehicleSortOptionDomain {
        switch option {
        case .recentlyAdded: return .createdAtDesc
        case .lowPrice: return .costAsc
        case .highPrice: return .costDesc
        case .lowMileage: return .mileageAsc
        case .newestYear: return .generationDesc
        }
    }

    // MARK: - DTO -> View Model mapping
    private func mapToVehicle(_ domain: VehicleSummaryDomainModel) -> Vehicle {
        let priceText: String = {
            guard let price = domain.price else { return "가격 정보 없음" }
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            return (formatter.string(from: NSNumber(value: price)) ?? String(price)) + "만원"
        }()

        let yearText: String = {
            if let year = domain.year, year > 0 {
                return "\(year)년"
            }
            return "-"
        }()

        let mileageText = formatMileage(domain.mileage ?? 0)
        return Vehicle(
            id: domain.id,
            imageName: nil,
            thumbnailURL: domain.thumbnailURL,
            title: domain.title,
            price: priceText,
            year: yearText,
            mileage: mileageText,
            fuelType: domain.vehicleType ?? "-",
            transmission: "-",
            location: domain.location.isEmpty ? "-" : domain.location,
            status: mapStatus(domain.status),
            postedDate: nil,
            isOnSale: domain.status == .active,
            isFavorite: domain.isLiked,
            likeCount: domain.likeCount
        )
    }

    private func formatMileage(_ value: Int) -> String {
        guard value > 0 else { return "-" }
        if value >= 10000 {
            let manValue = Double(value) / 10000.0
            return "\(formatManValue(manValue))만km"
        }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "ko_KR")
        let formatted = formatter.string(from: NSNumber(value: value)) ?? String(value)
        return "\(formatted)km"
    }

    private func formatManValue(_ value: Double) -> String {
        let scaled = (value * 10).rounded() / 10
        if abs(scaled.rounded() - scaled) < 0.0001 {
            return String(format: "%.0f", scaled)
        } else {
            return String(format: "%.1f", scaled)
        }
    }

    private func preloadVehicleImages(_ vehicles: [Vehicle]) async {
        guard !vehicles.isEmpty else { return }

        isPreloadingImages = true

        // Preload thumbnail images in parallel
        await withTaskGroup(of: Void.self) { group in
            for vehicle in vehicles {
                group.addTask {
                    guard let url = vehicle.thumbnailURL else { return }

                    // Check if image is already cached
                    let isCached = await MainActor.run {
                        ImageCache.shared.getImage(for: url) != nil
                    }
                    if isCached {
                        return // Already cached
                    }

                    // Check disk cache
                    if await ImageCache.shared.getDiskImage(for: url) != nil {
                        return // Available in disk cache
                    }

                    // Download and cache the image
                    do {
                        let (data, _) = try await URLSession.shared.data(from: url)
                        if let image = UIImage(data: data) {
                            await MainActor.run {
                                ImageCache.shared.setImage(image, for: url)
                            }
                            await ImageCache.shared.saveToDisk(image, for: url)
                        }
                    } catch {
                        // Silently fail for individual images
                    }
                }
            }
        }

        isPreloadingImages = false
    }
}

extension FindVehicleViewModel {
    fileprivate func mapStatus(_ status: VehicleStatusDomain) -> VehicleStatus {
        switch status {
        case .active: return .active
        case .reserved: return .reserved
        case .sold: return .sold
        }
    }
}
