//
//  VehicleSubmitButton.swift
//  campick
//
//  Created by 김호집 on 9/17/25.
//

import SwiftUI

struct VehicleSubmitButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            LinearGradient(
                colors: [AppColors.brandOrange, AppColors.brandLightOrange],
                startPoint: .leading,
                endPoint: .trailing
            )
            .frame(height: 48)
            .cornerRadius(8)
            .overlay(
                Text("매물 등록하기")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
            )
        }
        .padding(.top, 8)
    }
}