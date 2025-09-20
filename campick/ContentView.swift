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
    @State private var showSessionExpired = false

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
            showSessionExpired = true
        }
        .sheet(isPresented: $showSessionExpired) {
            SessionExpiredSheet {
                showSessionExpired = false
                UserState.shared.logout()
            }
            .presentationDetents([.fraction(0.3)])
            .presentationDragIndicator(.visible)
        }
        .interactiveDismissDisabled(showSessionExpired)
    }
}

#Preview {
    ContentView()
}

/// 세션 만료 시 재로그인을 안내하는 바텀 시트
private struct SessionExpiredSheet: View {
    let onReLogin: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Capsule()
                .fill(Color.white.opacity(0.3))
                .frame(width: 48, height: 5)
                .padding(.top, 12)

            VStack(spacing: 6) {
                Text("세션이 만료되었습니다.")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(Color.white)
                Text("보안을 위해 다시 로그인해 주세요.")
                    .font(.subheadline)
                    .foregroundStyle(AppColors.brandWhite70)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 20)

            Button(action: onReLogin) {
                Text("재로그인하기")
                    .font(.system(size: 17, weight: .bold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(AppColors.brandOrange)
                    .foregroundStyle(Color.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 20)

            Spacer()
        }
        .frame(maxWidth: .infinity)
        .frame(height: 220)
        .background(AppColors.background)
    }
}
