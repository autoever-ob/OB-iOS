//
//  ConnectivityBanner.swift
//  campick
//
//  Created by Assistant on 9/19/25.
//

import SwiftUI

struct ConnectivityBanner: View {
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "wifi.exclamationmark")
                .font(.system(size: 12, weight: .bold))
            Text("네트워크를 확인하세요")
                .font(.system(size: 13, weight: .semibold))
        }
        .foregroundStyle(.white)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
        .background(Color.red.opacity(0.9))
    }
}

