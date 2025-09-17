//
//  CompleteStepView.swift
//  campick
//
//  Created by Admin on 9/17/25.
//

import SwiftUI

struct CompleteStepView: View {
    var onAutoForward: () -> Void
    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle().fill(AppColors.brandOrange.opacity(0.22)).frame(width: 160, height: 160)
                Circle().stroke(AppColors.brandOrange, lineWidth: 4).frame(width: 120, height: 120)
                    .overlay(Image(systemName: "checkmark").font(.system(size: 56, weight: .bold)).foregroundStyle(AppColors.brandOrange))
            }
            Text("회원가입이 완료되었습니다!!").foregroundStyle(.white).font(.title3.bold())
        }
        .onAppear { DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { onAutoForward() } }
    }
}

