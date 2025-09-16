//
//  TopBarView.swift
//  campick
//
//  Created by Admin on 9/16/25.
//

import SwiftUI

struct TopBarView: View {
    let title: String
    var onBack: (() -> Void)? = nil
    
    var body: some View {
        ZStack {
            Text(title)
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .center)
            
            HStack {
                Button(action: { onBack?() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                        .frame(width: 34, height: 34)
                        .background(Circle().fill(Color.white.opacity(0.1)))
                }
                .padding(.leading, 12)
                Spacer()
            }
        }
    }
}
