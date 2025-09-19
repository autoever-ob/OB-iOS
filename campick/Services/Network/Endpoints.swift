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
    case logout
    case chatList
    case products

    static let baseURL = "https://campick.shop"

    var path: String {
        switch self {
        case .login: return "/api/member/login"
        case .signup: return "/api/member/signup"
        case .emailSend: return "/api/member/email/send"
        case .emailVerify: return "/api/member/email/verify"
        case .logout: return "/api/member/logout"
        case .chatList: return "/api/chat/my"
        case .products: return "/api/product"
        }
    }

    var url: String { Endpoint.baseURL + path }
}
