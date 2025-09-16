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
                        gradient: Gradient(colors: [Color.orange, Color.orange.opacity(0.8)]),
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
        Color(red: 0.043, green: 0.129, blue: 0.102)
            .ignoresSafeArea()

        ProfileActionComponent(onDetailTap: {
            print("프로필 상세보기 클릭")
        })
        .padding()
    }
}
