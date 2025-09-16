//
//  campickApp.swift
//  campick
//
//  Created by Admin on 9/15/25.
//

import SwiftUI
import FirebaseCore

@main
struct campickApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
