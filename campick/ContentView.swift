//
//  ContentView.swift
//  campick
//
//  Created by Admin on 9/15/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var userState = UserState.shared
    @StateObject private var network = NetworkMonitor.shared
    @State private var sessionExpiredAlert = false

    var body: some View {
        ZStack(alignment: .top) {
            Group {
            if userState.isLoggedIn {
                NavigationStack {
                    HomeView()
                }
                .id("loggedIn")
            } else {
                NavigationStack {
                    LoginView()
                }
                .id("loggedOut")
            }
            }
            .id(userState.isLoggedIn)

            if !network.isConnected {
                ConnectivityBanner()
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .zIndex(1)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: network.isConnected)
        .onReceive(NotificationCenter.default.publisher(for: .tokenReissueFailed)) { _ in
            sessionExpiredAlert = true
        }
        .alert(
            "세션이 만료되었습니다.",
            isPresented: $sessionExpiredAlert,
            actions: {
                Button("재로그인하기") {
                    sessionExpiredAlert = false
                    UserState.shared.logout()
                }
            },
            message: {
                Text("보안을 위해 다시 로그인해 주세요.")
                    .foregroundColor(AppColors.brandWhite70)
            }
        )
    }
}

#Preview {
    ContentView()
}
