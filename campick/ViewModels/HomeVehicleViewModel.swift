//
//  HomeVehicleViewModel.swift
//  campick
//
//  Created by Admin on 9/19/25.
//

import Foundation
import UIKit

final class HomeVehicleViewModel: ObservableObject {
    private let fetchRecommendationsUseCase: FetchVehicleRecommendationsUseCase
    private let toggleLikeUseCase: ToggleVehicleLikeUseCase

    struct VehicleCardData: Identifiable {
        let id: String
        let productId: String
        let title: String
        let thumbnailURLString: String
        let generationText: String
        let mileageText: String
        let priceText: String
        var isLiked: Bool
        var likeCount: Int
        let badge: String?
    }

    @Published var vehicles: [VehicleCardData] = []
    @Published var isLoading: Bool = false
    @Published var isPreloadingImages: Bool = false
    @Published var errorMessage: String?
    @Published private var likingIds: Set<String> = []

    init(
        fetchRecommendationsUseCase: FetchVehicleRecommendationsUseCase = VehicleDependencyContainer.shared.fetchRecommendationsUseCase(),
        toggleLikeUseCase: ToggleVehicleLikeUseCase = VehicleDependencyContainer.shared.toggleLikeUseCase()
    ) {
        self.fetchRecommendationsUseCase = fetchRecommendationsUseCase
        self.toggleLikeUseCase = toggleLikeUseCase
    }

    func loadRecommendVehicles() {
        isLoading = true
        Task {
            defer {
                Task { @MainActor in
                    self.isLoading = false
                }
            }
            do {
                let recommendations = try await fetchRecommendationsUseCase.execute()
                let viewData = recommendations.map { model in
                    VehicleCardData(
                        id: model.id,
                        productId: model.productId,
                        title: model.title,
                        thumbnailURLString: model.thumbnailURL?.absoluteString ?? "",
                        generationText: formatGeneration(from: model.generation),
                        mileageText: formatMileage(from: model.mileage),
                        priceText: formatPrice(from: model.price),
                        isLiked: model.isLiked,
                        likeCount: model.likeCount,
                        badge: model.highlightTag
                    )
                }
                await MainActor.run {
                    self.vehicles = viewData
                }
                await preloadVehicleImages(viewData)
            } catch {
                await MainActor.run {
                    self.errorMessage = ErrorMapper.map(error).localizedDescription
                }
            }
        }
    }

    func toggleLike(productId: String) {
        guard let idx = vehicles.firstIndex(where: { $0.productId == productId }) else { return }
        guard !likingIds.contains(productId) else { return }
        likingIds.insert(productId)

        var current = vehicles[idx]
        let previousLiked = current.isLiked
        let previousLikeCount = current.likeCount
        current.isLiked.toggle()
        current.likeCount = max(0, previousLikeCount + (current.isLiked ? 1 : -1))
        vehicles[idx] = current

        Task {
            defer {
                Task { @MainActor in
                    self.likingIds.remove(productId)
                }
            }
            do {
                try await toggleLikeUseCase.execute(productId: productId)
            } catch {
                await MainActor.run {
                    if let currentIndex = vehicles.firstIndex(where: { $0.productId == productId }) {
                        vehicles[currentIndex].isLiked = previousLiked
                        vehicles[currentIndex].likeCount = previousLikeCount
                    }
                }
            }
        }
    }

    // 버튼 비활성화를 위해 조회용
    func isLiking(_ productId: String) -> Bool {
        likingIds.contains(productId)
    }

    private func formatPrice(from value: Int?) -> String {
        guard let value else { return "-" }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let formatted = formatter.string(from: NSNumber(value: value)) ?? String(value)
        return formatted + "만원"
    }

    private func formatMileage(from value: Int?) -> String {
        guard let value else { return "-" }
        if value >= 10000 {
            let man = Double(value) / 10000.0
            return String(format: man.truncatingRemainder(dividingBy: 1) == 0 ? "%.0f만km" : "%.1f만km", man)
        }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let formatted = formatter.string(from: NSNumber(value: value)) ?? String(value)
        return formatted + "km"
    }

    private func formatGeneration(from value: Int?) -> String {
        guard let value else { return "-" }
        return "\(value)년식"
    }

    private func preloadVehicleImages(_ vehicles: [VehicleCardData]) async {
        guard !vehicles.isEmpty else { return }

        await MainActor.run {
            self.isPreloadingImages = true
        }

        // Preload thumbnail images in parallel
        await withTaskGroup(of: Void.self) { group in
            for vehicle in vehicles {
                group.addTask {
                    guard let url = URL(string: vehicle.thumbnailURLString) else { return }

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

        await MainActor.run {
            self.isPreloadingImages = false
        }
    }
}

