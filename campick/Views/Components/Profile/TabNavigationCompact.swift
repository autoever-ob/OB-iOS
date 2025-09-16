//
//  TabNavigationCompact.swift
//  campick
//
//  Created by 김호집 on 9/16/25.
//

import SwiftUI

struct TabNavigationCompact: View {
    @Binding var activeTab: ProfileViewViewModel.TabType
    let tabs: [ProfileViewViewModel.TabType]

    var body: some View {
        HStack(spacing: 16) {
            ForEach(tabs, id: \.self) { tab in
                Button(action: { activeTab = tab }) {
                    Text(tab.displayText)
                        .foregroundColor(activeTab == tab ? .white : .white.opacity(0.6))
                        .font(.system(size: 15, weight: .semibold))
                        .padding(.vertical, 14)
                        .frame(maxWidth: .infinity)
                        .background(
                            activeTab == tab ? AppColors.brandOrange : Color.white.opacity(0.1)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
        }
    }
}
