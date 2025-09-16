//
//  ProfileStatsComponent.swift
//  campick
//
//  Created by 김호집 on 9/16/25.
//

import SwiftUI

struct ProfileStatsComponent: View {
    let totalListings: Int
    let totalSales: Int

    var body: some View {
        HStack(spacing: 16) {
            ProfileStatCard(
                title: "등록 매물",
                value: "\(totalListings)"
            )

            ProfileStatCard(
                title: "판매 완료",
                value: "\(totalSales)"
            )
        }
    }
}

struct ProfileStatCard: View {
    let title: String
    let value: String

    var body: some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
            Text(title)
                .font(.caption)
                .foregroundColor(.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
        .padding(12)
        .background(Color.white.opacity(0.1))
        .cornerRadius(8)
    }
}

#Preview {
    ZStack {
        AppColors.background
            .ignoresSafeArea()

        ProfileStatsComponent(
            totalListings: 12,
            totalSales: 8
        )
        .padding()
    }
}
