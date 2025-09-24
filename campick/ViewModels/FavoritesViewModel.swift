import Foundation
import SwiftUI
import UIKit

@MainActor
final class FavoritesViewModel: ObservableObject {
    private let fetchFavoriteVehiclesUseCase: FetchFavoriteVehiclesUseCase
    private let toggleLikeUseCase: ToggleVehicleLikeUseCase

    @Published var favorites: [Vehicle] = []
    @Published var isLoading = false
    @Published var isPreloadingImages = false
    @Published var errorMessage: String? = nil

    init(
        fetchFavoriteVehiclesUseCase: FetchFavoriteVehiclesUseCase = VehicleDependencyContainer.shared.fetchFavoriteVehiclesUseCase(),
        toggleLikeUseCase: ToggleVehicleLikeUseCase = VehicleDependencyContainer.shared.toggleLikeUseCase()
    ) {
        self.fetchFavoriteVehiclesUseCase = fetchFavoriteVehiclesUseCase
        self.toggleLikeUseCase = toggleLikeUseCase
    }

    func load() {
        isLoading = true
        errorMessage = nil
        Task {
            defer { isLoading = false }
            do {
                let memberId = UserState.shared.memberId
                guard !memberId.isEmpty else {
                    errorMessage = "로그인이 필요합니다."
                    favorites = []
                    return
                }
                let page = try await fetchFavoriteVehiclesUseCase.execute(memberId: memberId, page: 0, size: 20)
                let mapped = page.items.map(mapToVehicle)
                favorites = mapped

                await preloadVehicleImages(mapped)
            } catch {
                let app = ErrorMapper.map(error)
                errorMessage = app.message
                favorites = []
            }
        }
    }

    private func mapToVehicle(_ item: VehicleSummaryDomainModel) -> Vehicle {
        let priceText = formatPrice(item.price ?? 0)
        let yearText = item.year.map { "\($0)년" } ?? "-"
        let mileageText = formatMileage(item.mileage ?? 0)
        let status = mapStatus(item.status)
        let thumbnailURL = item.thumbnailURL

        return Vehicle(
            id: item.id,
            imageName: nil,
            thumbnailURL: thumbnailURL,
            title: item.title,
            price: priceText,
            year: yearText,
            mileage: mileageText,
            fuelType: item.vehicleType ?? "-",
            transmission: "-",
            location: item.location,
            status: status,
            postedDate: nil,
            isOnSale: status == .active,
            isFavorite: true
        )
    }

    private func mapStatus(_ status: VehicleStatusDomain) -> VehicleStatus {
        switch status {
        case .active: return .active
        case .reserved: return .reserved
        case .sold: return .sold
        }
    }

    private func formatPrice(_ value: Int) -> String {
        guard value > 0 else { return "가격 정보 없음" }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "ko_KR")
        let formatted = formatter.string(from: NSNumber(value: value)) ?? String(value)
        return formatted
    }

    private func formatMileage(_ value: Int) -> String {
        guard value > 0 else { return "-" }
        if value >= 10000 {
            let manValue = Double(value) / 10000.0
            return "\(formatManValue(manValue))만km"
        }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
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

        await withTaskGroup(of: Void.self) { group in
            for vehicle in vehicles {
                group.addTask {
                    guard let url = vehicle.thumbnailURL else { return }

                    let isCached = await MainActor.run {
                        ImageCache.shared.getImage(for: url) != nil
                    }
                    if isCached {
                        return
                    }

                    if await ImageCache.shared.getDiskImage(for: url) != nil {
                        return
                    }

                    do {
                        let (data, _) = try await URLSession.shared.data(from: url)
                        if let image = UIImage(data: data) {
                            await MainActor.run {
                                ImageCache.shared.setImage(image, for: url)
                            }
                            await ImageCache.shared.saveToDisk(image, for: url)
                        }
                    } catch {
                        // Silently fail
                    }
                }
            }
        }

        isPreloadingImages = false
    }
}
