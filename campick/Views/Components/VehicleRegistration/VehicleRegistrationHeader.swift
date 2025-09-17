//
//  VehicleRegistrationHeader.swift
//  campick
//
//  Created by 김호집 on 9/17/25.
//

import SwiftUI

struct VehicleRegistrationHeader: View {
    let onCameraAction: () -> Void

    var body: some View {
        HStack {
            Color.clear
                .frame(width: 32, height: 32)

            Spacer()

            Text("차량 매물 등록")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)

            Spacer()

            Button(action: onCameraAction) {
                ZStack {
                    Circle()
                        .fill(AppColors.brandBackground)
                        .frame(width: 32, height: 32)

                    Image(systemName: "camera")
                        .foregroundColor(.white)
                        .font(.system(size: 14))
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }
}