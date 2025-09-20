//
//  Endpoints.swift
//  campick
//
//  Created by oyun on 9/17/25.
//

// MARK: - API 주소 정의
import Foundation

enum Endpoint {
    case login
    case signup
    case emailSend
    case emailVerify
    case carRecommend
    case logout
    case chatList
    case products
    case tokenReissue // 토큰 재발급 요청

    static let baseURL = "https://campick.shop"

    var path: String {
        switch self {
        case .login: return "/api/member/login"
        case .signup: return "/api/member/signup"
        case .emailSend: return "/api/member/email/send"
        case .emailVerify: return "/api/member/email/verify"
        case .carRecommend: return "/api/product/recommend"
        case .logout: return "/api/member/logout"
        case .chatList: return "/api/chat/my"
        case .products: return "/api/product"
        case .tokenReissue: return "/api/member/reissue"
        }
    }

    var url: String { Endpoint.baseURL + path }
}
