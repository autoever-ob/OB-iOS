//
//  ProfileStatsSection.swift
//  campick
//
//  Created by 김호집 on 9/16/25.
//

import SwiftUI

struct ProfileStatsSection: View {
    let totalListings: Int
    let activeListing: Int
    let totalSales: Int

    var body: some View {
        HStack(spacing: 0) {
            StatItemView(value: totalListings, label: "총 등록")
                .frame(maxWidth: .infinity)
            StatItemView(value: activeListing, label: "판매중")
                .frame(maxWidth: .infinity)
            StatItemView(value: totalSales, label: "판매완료")
                .frame(maxWidth: .infinity)
        }
        .padding(.vertical, 16)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.white.opacity(0.1)),
            alignment: .top
        )
    }
}

struct StatItemView: View {
    let value: Int
    let label: String

    var body: some View {
        VStack(spacing: 4) {
            Text("\(value)")
                .foregroundColor(.white)
                .font(.system(size: 24, weight: .bold))

            Text(label)
                .foregroundColor(.white.opacity(0.6))
                .font(.system(size: 14))
        }
    }
}
