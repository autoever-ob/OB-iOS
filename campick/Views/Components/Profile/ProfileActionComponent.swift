//
//  ProfileActionComponent.swift
//  campick
//
//  Created by 김호집 on 9/16/25.
//

import SwiftUI

struct ProfileActionComponent: View {
    let onDetailTap: () -> Void

    var body: some View {
        Button(action: onDetailTap) {
            Text("프로필 상세보기")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [AppColors.brandOrange, AppColors.brandLightOrange]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(12)
        }
    }
}

#Preview {
    ZStack {
        AppColors.background
            .ignoresSafeArea()

        ProfileActionComponent(onDetailTap: {
            print("프로필 상세보기 클릭")
        })
        .padding()
    }
}
