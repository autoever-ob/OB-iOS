//
//  SellerModalView.swift
//  campick
//
//  Created by 김호집 on 9/16/25.
//

import SwiftUI

struct SellerModalView: View {
    @StateObject private var viewModel: ProfileViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showSellerProfile = false

    init(seller: Seller) {
        self._viewModel = StateObject(wrappedValue: ProfileViewModel(seller: seller))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.043, green: 0.129, blue: 0.102)
                    .ignoresSafeArea()

                VStack(spacing: 24) {
                    ProfileHeaderComponent(seller: viewModel.seller)

                    ProfileStatsComponent(
                        totalListings: viewModel.seller.totalListings,
                        totalSales: viewModel.seller.totalSales
                    )

                    ProfileActionComponent {
                        showSellerProfile = true
                    }

                    Spacer()
                }
                .padding(24)
            }
            .navigationTitle("판매자 정보")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color(red: 0.043, green: 0.129, blue: 0.102), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("닫기") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
            .navigationDestination(isPresented: $showSellerProfile) {
                ProfileView(userId: viewModel.seller.id, isOwnProfile: false)
            }
        }
    }
}

#Preview {
    SellerModalView(
        seller: Seller(
            id: "1",
            name: "김캠핑",
            avatar: "bannerImage",
            totalListings: 12,
            totalSales: 8,
            rating: 4.8,
            isDealer: true
        )
    )
}
