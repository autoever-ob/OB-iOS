//
//  ProfileHeaderCompact.swift
//  campick
//
//  Created by 김호집 on 9/16/25.
//

import SwiftUI

struct ProfileHeaderCompact: View {
    let userProfile: UserProfile
    let isOwnProfile: Bool
    var onEditTapped: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Spacer()
                if isOwnProfile {
                    Button(action: {
                        onEditTapped?()
                    }) {
                        Text("편집")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(AppColors.brandOrange)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(AppColors.brandOrange.opacity(0.1))
                            .cornerRadius(6)
                    }
                }
            }

            ProfileAvatarSection(userProfile: userProfile)

            if let bio = userProfile.bio, !bio.isEmpty {
                Text(bio)
                    .foregroundColor(.white.opacity(0.9))
                    .font(.system(size: 14))
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 8)
            }

            ProfileStatsSection(
                totalListings: userProfile.totalListings,
                activeListing: userProfile.activeListing,
                totalSales: userProfile.totalSales
            )

            if !isOwnProfile {
                Button(action: {}) {
                    Text("메시지 보내기")
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .semibold))
                        .frame(maxWidth: .infinity, minHeight: 48)
                        .background(
                            LinearGradient(
                                colors: [AppColors.brandOrange, AppColors.brandLightOrange],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
        }
        .padding(16)
    }
}
