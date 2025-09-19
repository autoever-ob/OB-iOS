//
//  BottomBanner.swift
//  campick
//
//  Created by Admin on 9/18/25.
//

import SwiftUI

struct BottomBanner: View {
    var body: some View {
        ZStack {
            Image("bottomBannerImage")
                .resizable()
                .scaledToFill()
                .frame(height: 140)
                .cornerRadius(16)
                .clipped()
            
            LinearGradient(
                gradient: Gradient(colors: [.black.opacity(0.7), .clear]),
                startPoint: .leading,
                endPoint: .trailing
            )
            .cornerRadius(16)
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Image(systemName: "flame.fill")
                            .foregroundColor(AppColors.brandOrange)
                        Text("첫 거래 특별 혜택")
                            .foregroundColor(.white)
                            .font(.caption)
                            .fontWeight(.heavy)
                    }
                    Text("수수료 50% 할인")
                        .foregroundColor(.white)
                        .font(.headline)
                        .fontWeight(.heavy)
                }
                Spacer()
                NavigationLink(destination: EventDetailView()) {
                    Text("자세히 보기")
                        .bold()
                        .font(.system(size: 11))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(AppColors.brandOrange)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                }
            }
            .padding()
        }
    }
}

#Preview {
    BottomBanner()
}
