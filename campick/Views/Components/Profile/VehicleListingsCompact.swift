//
//  VehicleListingsCompact.swift
//  campick
//
//  Created by 김호집 on 9/16/25.
//

import SwiftUI

struct VehicleListingsCompact: View {
    let listings: [Vehicle]
    let isOwnProfile: Bool

    var body: some View {
        VStack(spacing: 10) {
            ForEach(listings, id: \.id) { listing in
                VehicleListingCardProfile(listing: listing, isOwnProfile: isOwnProfile)
            }
        }
    }
}
