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
    @Published var activeListings: [VehicleListing] = []
    @Published var soldListings: [VehicleListing] = []
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
        // Mock active listings
        activeListings = [
            VehicleListing(
                id: "1",
                title: "현대 포레스트 프리미엄",
                image: "bannerImage",
                price: 8900,
                year: 2022,
                mileage: 15000,
                status: .active,
                location: "서울 강남구",
                postedDate: "2024.01.15"
            ),
            VehicleListing(
                id: "2",
                title: "스타리아 캠퍼",
                image: "bannerImage",
                price: 7200,
                year: 2023,
                mileage: 8000,
                status: .reserved,
                location: "서울 강남구",
                postedDate: "2024.01.10"
            )
        ]

        // Mock sold listings
        soldListings = [
            VehicleListing(
                id: "3",
                title: "카니발 캠핑카",
                image: "bannerImage",
                price: 6500,
                year: 2021,
                mileage: 25000,
                status: .sold,
                location: "서울 강남구",
                postedDate: "2023.12.20"
            ),
            VehicleListing(
                id: "4",
                title: "봉고3 캠퍼밴",
                image: "bannerImage",
                price: 4200,
                year: 2020,
                mileage: 35000,
                status: .sold,
                location: "서울 강남구",
                postedDate: "2023.12.15"
            )
        ]
    }

    var currentListings: [VehicleListing] {
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
