//
//  ProfileViewModel.swift
//  campick
//
//  Created by 김호집 on 9/16/25.
//

import SwiftUI
import Combine

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var seller: Seller
    @Published var isLoading = false
    @Published var errorMessage: String?

    init(seller: Seller) {
        self.seller = seller
    }

    func viewDetailProfile() {
        print("프로필 상세보기: \(seller.name)")
    }

    func refreshSellerInfo() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isLoading = false
        }
    }

    var sellerDisplayName: String {
        return seller.name
    }

    var dealerBadgeText: String {
        return seller.isDealer ? "딜러" : ""
    }

    var ratingText: String {
        return String(format: "%.1f", seller.rating)
    }

    var totalListingsText: String {
        return "\(seller.totalListings)"
    }

    var totalSalesText: String {
        return "\(seller.totalSales)"
    }

    var showDealerBadge: Bool {
        return seller.isDealer
    }
}
