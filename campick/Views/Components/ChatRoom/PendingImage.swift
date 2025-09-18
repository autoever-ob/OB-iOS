//
//  PendingImage.swift
//  campick
//
//  Created by Admin on 9/18/25.
//

import SwiftUI
import UIKit

struct PendingImage: View {
    @Binding var pendingImage: UIImage?
    
    var body: some View {
        if let preview = pendingImage {
            HStack(spacing: 12) {
                ZStack(alignment: .topTrailing) {
                    Image(uiImage: preview)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipped()
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                        )
                        .allowsHitTesting(false)
                    Button {
                        withAnimation { pendingImage = nil }
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .background(Color.black.opacity(0.4))
                            .clipShape(Circle())
                    }
                    .offset(x: 6, y: -6)
                }
            }
            
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .background(.clear)
            .offset(x: 0, y: -80)
        }
        else {
            EmptyView()
        }
        
    }
}
