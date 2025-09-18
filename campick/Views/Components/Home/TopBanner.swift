//
//  TopBanner.swift
//  campick
//
//  Created by Admin on 9/18/25.
//

import SwiftUI

struct TopBanner: View {
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Image("bannerImage")
                .resizable()
                .scaledToFill()
                .frame(height: 200)
                .clipped()
                .cornerRadius(20)
                .shadow(radius: 5)
            
            LinearGradient(
                gradient: Gradient(colors: [.black.opacity(0.8), .clear]),
                startPoint: .bottom,
                endPoint: .top
            )
            .cornerRadius(20)
            
            VStack(alignment: .leading, spacing: 6) {
                Text("완벽한 캠핑카를\n찾아보세요")
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)
                    .padding(.bottom, 7)
                Text("전국 최다 프리미엄 캠핑카 매물")
                    .font(.system(size:13))
                    .foregroundColor(.white.opacity(0.9))
            }
            .padding()
        }
    }
}
