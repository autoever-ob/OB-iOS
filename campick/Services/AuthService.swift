//
//  AuthService.swift
//  campick
//
//  Created by 김호집 on 9/16/25.
//

import Foundation

class AuthService: ObservableObject {
    static let shared = AuthService()

    private init() {}

    // 로그아웃 API 호출
    func logout() async throws {
        guard let url = URL(string: "http://localhost:8080/api/member/logout") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // URLSession 구성 (쿠키 포함)
        let config = URLSessionConfiguration.default
        config.httpCookieAcceptPolicy = .always
        config.httpShouldSetCookies = true
        let session = URLSession(configuration: config)

        let (_, response) = try await session.data(for: request)

        if let httpResponse = response as? HTTPURLResponse {
            guard httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
        }
    }

    // 회원탈퇴 API 호출
    func withdrawal() async throws {
        guard let url = URL(string: "http://localhost:8080/api/member/signout") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // URLSession 구성 (쿠키 포함)
        let config = URLSessionConfiguration.default
        config.httpCookieAcceptPolicy = .always
        config.httpShouldSetCookies = true
        let session = URLSession(configuration: config)

        let (_, response) = try await session.data(for: request)

        if let httpResponse = response as? HTTPURLResponse {
            guard httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
        }
    }
}
