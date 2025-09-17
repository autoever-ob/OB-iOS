//
//  SalesStatusChip.swift
//  campick
//
//  Created by Admin on 9/16/25.
//

import SwiftUI

struct SalesStatusChip: View {
    let isOnSale: Bool

    var body: some View {
        Chip(
            text: isOnSale ? "판매중" : "판매완료",
            foreground: .white,
            background: isOnSale ? AppColors.brandLightGreen : AppColors.brandOrange,
            horizontalPadding: 8,
            verticalPadding: 4,
            font: .caption.bold(),
            cornerStyle: .capsule
        )
    }
}

