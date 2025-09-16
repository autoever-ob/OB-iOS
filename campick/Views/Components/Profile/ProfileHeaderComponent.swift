//
//  ProfileHeaderComponent.swift
//  campick
//
//  Created by 김호집 on 9/16/25.
//

import SwiftUI

struct ProfileHeaderComponent: View {
    let seller: Seller

    var body: some View {
        HStack(spacing: 16) {
            Image("bannerImage")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 64, height: 64)
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(seller.name)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)

                    if seller.isDealer {
                        Text("딜러")
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }

                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text("\(seller.rating, specifier: "%.1f")")
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                    Text("(평점)")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.6))
                }
            }

            Spacer()
        }
    }
}

#Preview {
    ZStack {
        Color(red: 0.043, green: 0.129, blue: 0.102)
            .ignoresSafeArea()

        ProfileHeaderComponent(
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
        .padding()
    }
}
