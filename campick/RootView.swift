//
//  RootView.swift
//  campick
//
//  Created by Admin on 9/20/25.
//

import SwiftUI

struct RootView: View {
    @StateObject private var userState = UserState.shared
    @StateObject private var network = NetworkMonitor.shared
    @State private var currentTab: Tab = .home
    
    var body: some View {
        ZStack(alignment: .top) {
            Group {
                if userState.isLoggedIn {
                    // 로그인 된 경우 → 탭바 포함 메인 화면
                    ZStack(alignment: .bottom) {
                        Group {
                            switch currentTab {
                            case .home:
                                HomeView()
                            case .vehicles:
                                FindVehicleView()
                            case .register:
                                VehicleRegistrationView()
                            case .favorites:
                                FavoritesView()
                            case .profile:
                                ProfileView(userId: "1", isOwnProfile: true)
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .ignoresSafeArea(.keyboard)
                        
                        BottomTabBarView(
                            currentSelection: currentTab,
                            onTabSelected: { selectedTab in
                                currentTab = selectedTab
                            }
                        )
                    }
                    .id("loggedIn")
                } else {
                    // 로그인 안된 경우 → 로그인 화면
                    NavigationStack {
                        LoginView()
                    }
                    .id("loggedOut")
                }
            }
            .id(userState.isLoggedIn)
            
            // 네트워크 연결 배너
            if !network.isConnected {
                ConnectivityBanner()
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .zIndex(1)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: network.isConnected)
    }
}

#Preview {
    RootView()
}
