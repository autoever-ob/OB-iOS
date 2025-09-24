import Foundation

@MainActor
final class VehicleDetailViewModel: ObservableObject {
    private let fetchDetailUseCase: FetchVehicleDetailUseCase
    private let updateStatusUseCase: UpdateVehicleStatusUseCase

    @Published private(set) var detail: VehicleDetailViewData?
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?

    init(
        fetchDetailUseCase: FetchVehicleDetailUseCase = VehicleDependencyContainer.shared.fetchVehicleDetailUseCase(),
        updateStatusUseCase: UpdateVehicleStatusUseCase = VehicleDependencyContainer.shared.updateVehicleStatusUseCase()
    ) {
        self.fetchDetailUseCase = fetchDetailUseCase
        self.updateStatusUseCase = updateStatusUseCase
    }

    func load(productId: String) async {
        if isLoading { return }
        isLoading = true
        defer { isLoading = false }
        errorMessage = nil

        do {
            let domain = try await fetchDetailUseCase.execute(productId: productId)
            detail = VehicleDetailViewData(domain: domain)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func changeStatus(productId: String, to newStatus: VehicleStatus) async {
        guard var current = detail else { return }
        let oldStatus = current.status
        // optimistic update
        current.status = newStatus
        detail = current
        do {
            try await updateStatusUseCase.execute(productId: productId, status: newStatus.asDomain)
        } catch {
            // rollback on failure
            var rollback = detail
            rollback?.status = oldStatus
            detail = rollback
            errorMessage = ErrorMapper.map(error).localizedDescription
        }
    }
}

struct VehicleDetailViewData {
    let id: String
    let title: String
    let priceText: String
    let yearText: String
    let mileageText: String
    let typeText: String
    let location: String
    let images: [String]
    let description: String
    let features: [String]
    let seller: Seller
    let isLiked: Bool
    let likeCount: Int
    var status: VehicleStatus

    init(domain: VehicleDetailDomainModel) {
        let formatter = DetailFormatter()
        id = domain.id
        title = domain.title.isEmpty ? domain.vehicleModel : domain.title
        priceText = formatter.price(from: domain.price)
        yearText = formatter.year(from: domain.generation)
        mileageText = formatter.mileage(from: domain.mileage)
        typeText = domain.vehicleType
        location = domain.location
        images = domain.images
        description = domain.description
        features = domain.features
        seller = formatter.seller(from: domain.seller)
        isLiked = domain.isLiked
        likeCount = domain.likeCount
        status = formatter.mapStatus(domain.status)
    }
}

private struct DetailFormatter {
    func price(from value: Int?) -> String {
        guard let value, value > 0 else { return "가격 정보 없음" }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let formatted = formatter.string(from: NSNumber(value: value)) ?? String(value)
        return formatted + "만원"
    }

    func year(from value: Int?) -> String {
        guard let value else { return "-" }
        return "\(value)년"
    }

    func mileage(from value: Int?) -> String {
        guard let intValue = value, intValue > 0 else { return "-" }
        if intValue >= 10000 {
            let man = Double(intValue) / 10000.0
            return String(format: man.truncatingRemainder(dividingBy: 1) == 0 ? "%.0f만km" : "%.1f만km", man)
        }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let formatted = formatter.string(from: NSNumber(value: intValue)) ?? String(intValue)
        return formatted + "km"
    }

    func seller(from dto: VehicleSellerDomainModel) -> Seller {
        Seller(
            id: dto.id,
            name: dto.name.isEmpty ? dto.nickname : dto.name,
            avatar: dto.avatarURL.isEmpty ? "bannerImage" : dto.avatarURL,
            totalListings: dto.totalListings,
            totalSales: dto.totalSales,
            rating: 0,
            isDealer: dto.isDealer
        )
    }

    func mapStatus(_ status: VehicleStatusDomain) -> VehicleStatus {
        switch status {
        case .active: return .active
        case .reserved: return .reserved
        case .sold: return .sold
        }
    }
}

private extension VehicleStatus {
    var asDomain: VehicleStatusDomain {
        switch self {
        case .active: return .active
        case .reserved: return .reserved
        case .sold: return .sold
        }
    }
}
