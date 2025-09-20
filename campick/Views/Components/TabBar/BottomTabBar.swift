//
//  BottomTabBar.swift
//  campick
//
//  Created by 오윤 on 9/15/25.
//

import SwiftUI


enum Tab {
    case home, vehicles, register, favorites, profile
}

struct BottomTabBarView: View {
    var currentSelection: Tab
    var onTabSelected: (Tab) -> Void
    
    var body: some View {
        HStack {
            // 홈
            TabButton(tab: .home, currentSelection: currentSelection, onTabSelected: onTabSelected)
            Spacer()
            TabButton(tab: .vehicles, currentSelection: currentSelection, onTabSelected: onTabSelected)
            Spacer()
            TabButton(tab: .register, currentSelection: currentSelection, onTabSelected: onTabSelected)
            Spacer()
            TabButton(tab: .favorites, currentSelection: currentSelection, onTabSelected: onTabSelected)
            Spacer()
            TabButton(tab: .profile, currentSelection: currentSelection, onTabSelected: onTabSelected)
        }
        .padding(.horizontal)
        .padding(.top, 10)
        .padding(.bottom, 20)
        .frame(maxWidth: .infinity)
        .background(
            AppColors.brandBackground
                .ignoresSafeArea(edges: .bottom)
                .overlay(
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 1),
                    alignment: .top
                )
        )
    }
}

struct TabButton: View {
    var tab: Tab
    var currentSelection: Tab
    var onTabSelected: (Tab) -> Void
    
    var body: some View {
        Button(action: {
            onTabSelected(tab)
        }) {
            TabItems(
                icon: iconName(for: tab),
                label: labelName(for: tab),
                active: currentSelection == tab
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func iconName(for tab: Tab) -> String {
        switch tab {
        case .home: return "house.fill"
        case .vehicles: return "car"
        case .register: return "plus.circle"
        case .favorites: return "heart"
        case .profile: return "person"
        }
    }
    
    private func labelName(for tab: Tab) -> String {
        switch tab {
        case .home: return "홈"
        case .vehicles: return "매물찾기"
        case .register: return "매물등록"
        case .favorites: return "찜"
        case .profile: return "프로필"
        }
    }
}

struct TabItems: View {
    var icon: String
    var label: String
    var active: Bool = false
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .foregroundColor(active ? AppColors.brandOrange : .white.opacity(0.6))
            Text(label)
                .font(.caption2)
                .foregroundColor(active ? AppColors.brandOrange : .white.opacity(0.6))
        }
    }
}
