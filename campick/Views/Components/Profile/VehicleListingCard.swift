//
//  VehicleListingCard.swift
//  campick
//
//  Created by 김호집 on 9/16/25.
//

import SwiftUI

struct VehicleListingCardProfile: View {
    let listing: Vehicle
    let isOwnProfile: Bool

    var body: some View {
        NavigationLink(destination: VehicleDetailView(vehicleId: listing.id)) {
            HStack(spacing: 12) {
            ZStack(alignment: .topLeading) {
                Image("bannerImage")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 90, height: 90)
                    .clipped()
                    .cornerRadius(8)

                Text(listing.status.displayText)
                    .foregroundColor(.white)
                    .font(.system(size: 10, weight: .medium))
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(listing.status.color)
                    .clipShape(Capsule())
                    .padding(.top, 6)
                    .padding(.leading, 6)
            }

            VStack(alignment: .leading, spacing: 8) {
                // Title
                Text(listing.title)
                    .foregroundColor(.white)
                    .font(.system(size: 15, weight: .semibold))
                    .lineLimit(1)

                Text("\(listing.price)만원")
                    .foregroundColor(AppColors.brandOrange)
                    .font(.system(size: 17, weight: .bold))

                HStack(spacing: 12) {
                    HStack(spacing: 4) {
                        Image(systemName: "calendar")
                            .foregroundColor(.white.opacity(0.6))
                            .font(.system(size: 10))


                        Text("\(String(listing.year))년")
                            .foregroundColor(.white.opacity(0.6))
                            .font(.system(size: 13))
                    }

                    HStack(spacing: 4) {
                        Image(systemName: "gauge")
                            .foregroundColor(.white.opacity(0.6))
                            .font(.system(size: 10))

                        Text("\(listing.mileage)km")
                            .foregroundColor(.white.opacity(0.6))
                            .font(.system(size: 13))
                    }
                }

                // Location and Date
                HStack {
                    Text(listing.location)
                        .foregroundColor(.white.opacity(0.6))
                        .font(.system(size: 13))

                    Spacer()

                    if let posted = listing.postedDate {
                        Text(posted)
                            .foregroundColor(.white.opacity(0.6))
                            .font(.system(size: 13))
                    }
                }
            }

            if isOwnProfile {
                Image(systemName: "chevron.right")
                    .foregroundColor(.white.opacity(0.4))
                    .font(.system(size: 14))
            }
            }
            .padding(12)
            .background(Color.white.opacity(0.05))
            .cornerRadius(10)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
