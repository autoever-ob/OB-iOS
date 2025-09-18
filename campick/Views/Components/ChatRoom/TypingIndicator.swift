//
//  TypingIndicator.swift
//  campick
//
//  Created by Admin on 9/18/25.
//
import SwiftUI

// MARK: - 타이핑 인디케이터
struct TypingIndicator: View {
    @State private var animate = false
    
    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<3) { i in
                Circle()
                    .fill(Color.gray)
                    .frame(width: 8, height: 8)
                    .offset(y: animate ? -4 : 4)
                    .animation(
                        Animation
                            .easeInOut(duration: 0.6)
                            .repeatForever()
                            .delay(Double(i) * 0.2),
                        value: animate
                    )
            }
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(16)
        .onAppear {
            animate = true
        }
    }
}
