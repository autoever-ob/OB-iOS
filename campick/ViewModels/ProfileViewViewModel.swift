//
//  ProfileViewViewModel.swift
//  campick
//
//  Created by 김호집 on 9/16/25.
//

import SwiftUI
import Combine

class ProfileViewViewModel: ObservableObject {
    @Published var userProfile: UserProfile
    @Published var activeListings: [Vehicle] = []
    @Published var soldListings: [Vehicle] = []
    @Published var activeTab: TabType = .active
    @Published var showEditModal = false
    @Published var showLogoutModal = false
    @Published var showWithdrawalModal = false
    @Published var showPasswordChangeView = false
    @Published var editForm = EditForm()
    @Published var isLoading = false

    let userId: String
    let isOwnProfile: Bool

    enum TabType: String, CaseIterable {
        case active = "active"
        case sold = "sold"

        var displayText: String {
            switch self {
            case .active: return "판매중 매물"
            case .sold: return "판매완료"
            }
        }
    }

    struct EditForm {
        var name: String = ""
        var bio: String = ""
        var phone: String = ""
    }

    init(userId: String, isOwnProfile: Bool) {
        self.userId = userId
        self.isOwnProfile = isOwnProfile

        // Mock data initialization
        self.userProfile = UserProfile(
            id: "1",
            name: "김캠핑",
            avatar: "https://readdy.ai/api/search-image?query=Professional%20headshot%20portrait",
            joinDate: "2023.03",
            rating: 4.8,
            totalListings: 12,
            activeListing: 4,
            totalSales: 8,
            isDealer: true,
            location: "서울 강남구",
            phone: "010-1234-5678",
            email: "user@example.com",
            bio: "캠핑과 여행을 사랑하는 모터홈 전문 딜러입니다. 고객 만족을 최우선으로 생각하며, 최상의 캠핑카를 제공해드립니다."
        )

        loadListings()
    }

    func loadListings() {
        // Mock active listings (mapped to unified Vehicle)
        activeListings = [
            Vehicle(
                id: "1",
                imageName: "bannerImage",
                thumbnailURL: nil,
                title: "현대 포레스트 프리미엄",
                price: "\(8900.formatted())만원",
                year: "2022년",
                mileage: "\(15000.formatted())km",
                fuelType: "-",
                transmission: "-",
                location: "서울 강남구",
                status: .active,
                postedDate: "2024.01.15",
                isOnSale: true,
                isFavorite: false
            ),
            Vehicle(
                id: "2",
                imageName: "bannerImage",
                thumbnailURL: nil,
                title: "스타리아 캠퍼",
                price: "\(7200.formatted())만원",
                year: "2023년",
                mileage: "\(8000.formatted())km",
                fuelType: "-",
                transmission: "-",
                location: "서울 강남구",
                status: .reserved,
                postedDate: "2024.01.10",
                isOnSale: true,
                isFavorite: false
            )
        ]

        // Mock sold listings
        soldListings = [
            Vehicle(
                id: "3",
                imageName: "bannerImage",
                thumbnailURL: nil,
                title: "카니발 캠핑카",
                price: "\(6500.formatted())만원",
                year: "2021년",
                mileage: "\(25000.formatted())km",
                fuelType: "-",
                transmission: "-",
                location: "서울 강남구",
                status: .sold,
                postedDate: "2023.12.20",
                isOnSale: false,
                isFavorite: false
            ),
            Vehicle(
                id: "4",
                imageName: "bannerImage",
                thumbnailURL: nil,
                title: "봉고3 캠퍼밴",
                price: "\(4200.formatted())만원",
                year: "2020년",
                mileage: "\(35000.formatted())km",
                fuelType: "-",
                transmission: "-",
                location: "서울 강남구",
                status: .sold,
                postedDate: "2023.12.15",
                isOnSale: false,
                isFavorite: false
            )
        ]
    }

    var currentListings: [Vehicle] {
        switch activeTab {
        case .active:
            return activeListings
        case .sold:
            return soldListings
        }
    }

    func editProfile() {
        showEditModal = true
    }

    func changePassword() {
        showPasswordChangeView = true
    }

    func logout() {
        Task {
            do {
                try await AuthService.shared.logout()
                DispatchQueue.main.async {
                    // TODO: Navigate to login screen or clear user data
                    print("Logout successful")
                }
            } catch {
                DispatchQueue.main.async {
                    print("Logout failed: \(error.localizedDescription)")
                }
            }
        }
    }

    func deleteAccount() {
        showWithdrawalModal = true
    }

    func confirmDeleteAccount() {
        Task {
            do {
                try await AuthService.shared.withdrawal()
                DispatchQueue.main.async {
                    // TODO: Navigate to login screen or app start
                    print("Account withdrawal successful")
                }
            } catch {
                DispatchQueue.main.async {
                    print("Account withdrawal failed: \(error.localizedDescription)")
                }
            }
        }
    }
}
