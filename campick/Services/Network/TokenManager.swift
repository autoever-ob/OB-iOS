//
//  TokenManager.swift
//  campick
//
//  Created by oyun on 9/17/25.
//

import Foundation

// Keychain 연동으로 토큰을 보관합니다.



// MARK: - 앱 전체에서 토큰을 관리하는 싱글톤 클래스
// - accessToken 읽기
// - accessToken 저장
// - refreshToken API 호출
final class TokenManager {
    // 싱글톤 인스턴스 (앱 전체에서 하나만 사용)
    static let shared = TokenManager()
    private init() {}

    // 현재 저장된 Access Token 반환
    // 없으면 ""(빈 문자열) 리턴
    var accessToken: String {
        KeychainManager.getToken(forKey: "accessToken") ?? ""
    }

    // 새로운 Access Token을 저장
    func saveAccessToken(_ token: String) {
        KeychainManager.saveToken(token, forKey: "accessToken")
    }

    // Refresh Token을 이용해 새로운 Access Token 발급받기
    // 실제 API 호출 부분은 아직 미구현
    // completion(true) → 갱신 성공
    // completion(false) → 갱신 실패
    func refreshToken(completion: @escaping (Bool) -> Void) {
        // 현재는 액세스 토큰만 사용하므로 리프레시 미사용
        completion(false)
    }
}
