//
//  AuthService.swift
//  campick
//
//  Created by 김호집 on 9/16/25.
//

import Foundation
import Alamofire

class AuthService: ObservableObject {
    static let shared = AuthService()

    private init() {}

    // 로그아웃 API 호출 (Alamofire 사용)
    func logout() async throws {
        let url = "http://localhost:8080/api/member/logout"
        let request = APIService.shared
            .request(url, method: .post)
            .validate()
        _ = try await request.serializingData().value
    }

    // 회원탈퇴 API 호출 (Alamofire 사용)
    func withdrawal() async throws {
        let url = "http://localhost:8080/api/member/signout"
        let request = APIService.shared
            .request(url, method: .delete)
            .validate()
        _ = try await request.serializingData().value
    }
}
