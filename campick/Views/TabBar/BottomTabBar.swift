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
    var body: some View {
        HStack{
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
            if currentSelection == .profile {
                TabItems(icon: "person", label: "프로필", active: true)
            } else {
                NavigationLink(destination: ProfileView(userId: "1", isOwnProfile: true)) {
                    TabItems(icon: "person", label: "프로필", active: false)
                }
            }
        }
        .padding(.horizontal)
        .padding(.top,10)
        .padding(.bottom,20)
        .frame(maxWidth: .infinity)
        .background(
            AppColors.brandBackground
                .ignoresSafeArea(edges: .bottom)
                .overlay(
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height:1),
                    alignment: .top
                )
        )
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
