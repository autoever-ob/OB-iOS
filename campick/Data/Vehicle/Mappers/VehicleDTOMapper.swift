import Foundation

enum VehicleDataMapper {
    static func mapRecommendation(_ response: VehicleResponse) -> [VehicleRecommendationDomainModel] {
        let items = [response.newVehicle, response.hotVehicle]
        return items.enumerated().map { index, dto in
            VehicleRecommendationDomainModel(
                id: "recommendation_\(index)_\(dto.productId)",
                productId: String(dto.productId),
                title: dto.title,
                price: parsePrice(dto.price),
                generation: dto.generation,
                mileage: parseMileage(dto.mileage),
                thumbnailURL: URL(string: dto.thumbNail ?? ""),
                isLiked: dto.isLiked,
                likeCount: dto.likeCount ?? 0,
                location: dto.location,
                highlightTag: index == 0 ? "NEW" : "HOT"
            )
        }
    }

    static func mapSummaryPage(_ page: Page<ProductItemDTO>) -> VehicleListPageDomainModel {
        let items = page.content.map(mapSummary)
        return VehicleListPageDomainModel(
            items: items,
            totalElements: page.totalElements,
            totalPages: page.totalPages,
            currentPage: page.number,
            isLast: page.last
        )
    }

    static func mapSummary(_ dto: ProductItemDTO) -> VehicleSummaryDomainModel {
        VehicleSummaryDomainModel(
            id: String(dto.productId),
            title: dto.title,
            price: parsePrice(dto.price),
            mileage: parseMileage(dto.mileage),
            year: dto.generation,
            vehicleType: dto.fuelType,
            location: dto.location,
            thumbnailURL: URL(string: dto.thumbNail ?? ""),
            isLiked: dto.isLiked,
            likeCount: dto.likeCount ?? 0,
            status: mapStatus(dto.status)
        )
    }

    static func mapFavoritePage(_ page: MyProductListPageData) -> VehicleFavoritePageDomainModel {
        let items = page.content.map { item in
            VehicleSummaryDomainModel(
                id: String(item.productId),
                title: item.title,
                price: item.cost,
                mileage: item.mileage,
                year: item.generation,
                vehicleType: item.fuelType,
                location: item.location,
                thumbnailURL: URL(string: item.thumbnailUrls.first ?? ""),
                isLiked: true,
                likeCount: 0,
                status: mapStatus(item.status)
            )
        }
        return VehicleFavoritePageDomainModel(items: items, totalElements: page.totalElements)
    }

    static func mapDetail(_ dto: ProductDetailDTO) -> VehicleDetailDomainModel {
        let seller = VehicleSellerDomainModel(
            id: String(dto.user?.userId ?? 0),
            name: dto.user?.nickName ?? "",
            nickname: dto.user?.nickName ?? "",
            phoneNumber: "",
            email: "",
            avatarURL: "",
            totalListings: dto.user?.sellingCount ?? 0,
            totalSales: dto.user?.completeCount ?? 0,
            isDealer: (dto.user?.role ?? "").uppercased() == "DEALER"
        )

        return VehicleDetailDomainModel(
            id: String(dto.productId ?? 0),
            title: dto.title ?? "",
            price: parsePrice(dto.price ?? ""),
            generation: parseGeneration(dto.generation),
            mileage: parseMileage(dto.mileage ?? ""),
            vehicleType: dto.vehicleType ?? "",
            vehicleModel: dto.vehicleModel ?? "",
            location: dto.location ?? "",
            description: dto.description ?? "",
            images: dto.productImage ?? [],
            features: dto.option?.filter { $0.isInclude }.map { $0.optionName } ?? [],
            status: mapStatus(dto.status ?? ""),
            isLiked: dto.isLiked ?? false,
            likeCount: dto.likeCount ?? 0,
            seller: seller,
            fuelType: dto.fuelType ?? "",
            transmission: dto.transmission ?? "",
            plateHash: dto.plateHash ?? ""
        )
    }

    static func mapMetadata(_ response: ProductInfoResponse) -> VehicleMetadataDomainModel {
        VehicleMetadataDomainModel(
            types: response.type,
            models: response.model,
            options: response.option
        )
    }

    static func mapRegistrationResult(_ response: ApiResponse<Int>) -> VehicleRegistrationResultDomainModel {
        VehicleRegistrationResultDomainModel(
            success: response.success,
            statusCode: response.status ?? 0,
            message: response.message ?? "",
            productId: response.data
        )
    }

    // MARK: - Helpers
    private static func parsePrice(_ raw: String) -> Int? {
        let digits = raw.filter { $0.isNumber }
        return Int(digits)
    }

    private static func parseMileage(_ raw: String) -> Int? {
        if raw.isEmpty { return nil }
        let lower = raw.lowercased().replacingOccurrences(of: " ", with: "")
        if lower.contains("만") {
            let value = lower.replacingOccurrences(of: "만km", with: "")
                .replacingOccurrences(of: "km", with: "")
                .filter { $0.isNumber || $0 == "." }
            if let doubleValue = Double(value) {
                return Int(doubleValue * 10_000)
            }
        }
        let digits = lower.replacingOccurrences(of: "km", with: "").filter { $0.isNumber }
        return Int(digits)
    }

    private static func parseGeneration(_ raw: String?) -> Int? {
        guard let raw, !raw.isEmpty else { return nil }
        return Int(raw.filter { $0.isNumber })
    }

    private static func mapStatus(_ raw: String) -> VehicleStatusDomain {
        switch raw.uppercased() {
        case "AVAILABLE", "ACTIVE": return .active
        case "RESERVED": return .reserved
        case "SOLD", "SOLD_OUT", "COMPLETED": return .sold
        default: return .active
        }
    }
}
