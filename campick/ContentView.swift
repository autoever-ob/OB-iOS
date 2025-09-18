//
//  ContentView.swift
//  campick
//
//  Created by Admin on 9/15/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var userState = UserState.shared

    var body: some View {
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
    }
}

#Preview {
    ContentView()
}
