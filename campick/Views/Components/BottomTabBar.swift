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

struct BottomTabBar: ToolbarContent {
    var currentSelection: Tab
    var body: some ToolbarContent {
        ToolbarItemGroup(placement: .bottomBar) {
            NavigationLink(destination: HomeView()) {
                TabItems(icon: "house.fill", label: "홈", active: currentSelection == .home)
            }
            Spacer()
            NavigationLink(destination: Text("매물찾기")) {
                TabItems(icon: "car", label: "매물찾기", active: currentSelection == .vehicles)
            }
            Spacer()
            NavigationLink(destination: Text("매물등록")) {
                TabItems(icon: "plus.circle", label: "매물등록", active: currentSelection == .register)
            }
            Spacer()
            NavigationLink(destination: Text("찜리스트")) {
                TabItems(icon: "heart", label: "찜", active: currentSelection == .favorites)
            }
            Spacer()
            NavigationLink(destination: Text("프로필")) {
                TabItems(icon: "person", label: "프로필", active: currentSelection == .profile)
            }
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
                .foregroundColor(active ? .brandOrange : .white.opacity(0.6))
            Text(label)
                .font(.caption2)
                .foregroundColor(active ? .brandOrange : .white.opacity(0.6))
        }
    }
}
