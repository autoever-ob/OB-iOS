//
//  SignupProgressView.swift
//  campick
//
//  Created by Admin on 9/17/25.
//

import SwiftUI

struct SignupProgress: View {
    /// 고정 폭 픽셀 값(옵션)
    var progressWidth: CGFloat? = nil
    /// 0.0 ~ 1.0 사이의 진행도(옵션)
    var progress: CGFloat? = nil
    /// 화면 등장 시 특정 진행도에서 목표 진행도로 애니메이션 시작
    /// 설정하지 않으면 0에서 시작
    var startFrom: CGFloat? = nil
    /// 화면 등장 시 애니메이션 실행 여부
    var animateOnAppear: Bool = true
    /// 진행 변화 애니메이션 설정
    var animation: Animation = .easeInOut(duration: 0.35)

    @State private var animatedProgress: CGFloat = 0

    var body: some View {
        VStack(alignment: .leading) {
            GeometryReader { proxy in
                let totalWidth = proxy.size.width
                let base = min(max(progress ?? 0, 0), 1)
                let shown = animateOnAppear ? animatedProgress : base
                let computedWidth: CGFloat = {
                    if let progressWidth { return progressWidth }
                    return totalWidth * shown
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
                        .animation(animation, value: shown)
                }
                .onAppear {
                    guard animateOnAppear else { return }
                    if let startFrom {
                        animatedProgress = min(max(startFrom, 0), 1)
                    } else {
                        animatedProgress = 0
                    }
                    withAnimation(animation) {
                        animatedProgress = base
                    }
                }
                .onChange(of: progress ?? 0) { _, newValue in
                    guard animateOnAppear else { return }
                    let target = min(max(newValue, 0), 1)
                    withAnimation(animation) { animatedProgress = target }
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
            SignupProgress(progressWidth: 120)

            // 퍼센트 방식
            SignupProgress(progress: 0.5)
        }
        .padding()
    }
}
