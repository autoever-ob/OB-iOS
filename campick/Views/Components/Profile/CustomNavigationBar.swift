//
//  CustomNavigationBar.swift
//  campick
//
//  Created by 김호집 on 9/16/25.
//

import SwiftUI

struct CustomNavigationBar: View {
    let title: String
    let isOwnProfile: Bool
    let onEditTapped: () -> Void

    var body: some View {
        HStack {
            Button(action: {
                // 뒤로가기 액션
            }) {
                Image(systemName: "arrow.left")
                    .foregroundColor(.white)
                    .frame(width: 32, height: 32)
                    .background(Color.white.opacity(0.1))
                    .clipShape(Circle())
            }

            Spacer()

            Text(title)
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .semibold))

            Spacer()

            if isOwnProfile {
                Button(action: onEditTapped) {
                    Image(systemName: "gearshape")
                        .foregroundColor(.white)
                        .frame(width: 32, height: 32)
                        .background(Color.white.opacity(0.1))
                        .clipShape(Circle())
                }
            } else {
                Spacer()
                    .frame(width: 32, height: 32)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            Color(red: 0.043, green: 0.129, blue: 0.102).opacity(0.95)
                .background(.ultraThinMaterial)
        )
    }
}
