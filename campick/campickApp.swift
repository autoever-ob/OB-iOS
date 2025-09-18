//
//  campickApp.swift
//  campick
//
//  Created by Admin on 9/15/25.
//

import SwiftUI

@main
struct campickApp: App {
    init() {
        UserState.shared.loadUserData()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
