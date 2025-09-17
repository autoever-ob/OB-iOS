//
//  TokenManager.swift
//  campick
//
//  Created by oyun on 9/17/25.
//

import Foundation



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
        // TODO: 토큰 저장 코드 구현 부분
        UserDefaults.standard.string(forKey: "accessToken") ?? "" // 지우면 에러 발생해서 남겨둡니다!
    }

    // 새로운 Access Token을 저장
    
    func saveAccessToken(_ token: String) {
         // TODO: 토큰 호출 코드 구현 부분
    }

    // Refresh Token을 이용해 새로운 Access Token 발급받기
    // 실제 API 호출 부분은 아직 미구현
    // completion(true) → 갱신 성공
    // completion(false) → 갱신 실패
    func refreshToken(completion: @escaping (Bool) -> Void) {
        // TODO: 실제 refresh API 호출 구현
        // 성공 시 토큰 업데이트 후 completion(true)
        completion(false)
    }
}
