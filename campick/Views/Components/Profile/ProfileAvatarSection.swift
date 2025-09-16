//
//  ProfileAvatarSection.swift
//  campick
//
//  Created by 김호집 on 9/16/25.
//

import SwiftUI

struct ProfileAvatarSection: View {
    let userProfile: UserProfile

    var body: some View {
        HStack(spacing: 16) {
            // Avatar
            AsyncImage(url: URL(string: userProfile.avatar)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .frame(width: 64, height: 64)
            .clipShape(Circle())

            VStack(alignment: .leading, spacing: 8) {
                // Name and Dealer Badge
                HStack(spacing: 8) {
                    Text(userProfile.name)
                        .foregroundColor(.white)
                        .font(.system(size: 18, weight: .bold))

                    if userProfile.isDealer {
                        Text("딜러")
                            .foregroundColor(.white)
                            .font(.system(size: 11, weight: .medium))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.orange)
                            .clipShape(Capsule())
                    }
                }

                // Rating
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.system(size: 12))

                    Text("\(userProfile.rating, specifier: "%.1f")")
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .medium))

                    Text("(\(userProfile.totalSales)건 판매)")
                        .foregroundColor(.white.opacity(0.6))
                        .font(.system(size: 12))
                }

                // Join Date and Location
                HStack(spacing: 16) {
                    Text("가입일 \(userProfile.joinDate)")
                        .foregroundColor(.white.opacity(0.6))
                        .font(.system(size: 12))

                    Text(userProfile.location)
                        .foregroundColor(.white.opacity(0.6))
                        .font(.system(size: 12))
                }
            }

            Spacer()
        }
    }
}
