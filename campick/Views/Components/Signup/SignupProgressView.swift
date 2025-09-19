//
//  SignupProgressView.swift
//  campick
//
//  Created by Admin on 9/17/25.
//

import SwiftUI

struct SignupProgressView: View {
    
    /// 고정 폭 픽셀 값(옵션)
    var progressWidth: CGFloat? = nil
    /// 0.0 ~ 1.0 사이의 진행도(옵션)
    var progress: CGFloat? = nil

    var body: some View {
        VStack(alignment: .leading) {
            

            GeometryReader { proxy in
                let totalWidth = proxy.size.width
                let clampedProgress = min(max(progress ?? 0, 0), 1)
                let computedWidth: CGFloat = {
                    if let progressWidth {
                        return progressWidth
                    } else {
                        return totalWidth * clampedProgress
                    }
                }()

                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.black.opacity(0.1))
                        .frame(height: 8)
                        .cornerRadius(10)

                    Rectangle()
                        .fill(AppColors.brandOrange)
                        .frame(width: computedWidth, height: 8)
                        .cornerRadius(10)
                }
            }
            .frame(height: 8)
        }
    }
}

#Preview {
    ZStack {
        AppColors.brandBackground.ignoresSafeArea()
        VStack(spacing: 24) {
            // 고정 폭 방식
            SignupProgressView(progressWidth: 120)

            // 퍼센트 방식
            SignupProgressView(progress: 0.5)
        }
        .padding()
    }
}
