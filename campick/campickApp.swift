//
//  campickApp.swift
//  campick
//
//  Created by Admin on 9/15/25.
//

import SwiftUI

@main
struct campickApp: App {
    @Environment(\.scenePhase) private var scenePhase

    init() {
        UserState.shared.loadUserData() // 저장된 사용자/토큰으로 초기 상태 복원
        TokenManager.shared.scheduleAutoRefresh()
        Task {
            await TokenManager.shared.refreshAccessTokenIfNeeded() // 앱 시작 직후 만료 임박 토큰 갱신
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .onChange(of: scenePhase) { newPhase in
            switch newPhase {
            case .active:
                UserState.shared.loadUserData() // 백그라운드에서 돌아와도 로그인 상태를 즉시 복구
                TokenManager.shared.handleAppDidBecomeActive()
            case .background:
                TokenManager.shared.handleAppDidEnterBackground()
            default:
                break
            }
        }
    }
}
