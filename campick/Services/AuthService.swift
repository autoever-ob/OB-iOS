//
//  AuthService.swift
//  campick
//
//  Created by 김호집 on 9/16/25.
//

import Foundation
class AuthService: ObservableObject {
    static let shared = AuthService()

    private let logoutUseCase: LogoutUseCase

    private init(logoutUseCase: LogoutUseCase = AuthDependencyContainer.shared.logoutUseCase()) {
        self.logoutUseCase = logoutUseCase
    }

    // 로그아웃 API 호출: Clean Architecture 경유
    func logout() async throws {
        do {
            AppLog.info("Requesting logout", category: "AUTH")
            try await logoutUseCase.execute()
            AppLog.info("Logout success", category: "AUTH")
        } catch {
            let appError = ErrorMapper.map(error)
            AppLog.error("Logout failed: \(appError.message)", category: "AUTH")
            throw appError
        }
    }

    // 회원탈퇴 API 미구현: 현재는 사용하지 않음
}
