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
    }
}

#Preview {
    ContentView()
}
