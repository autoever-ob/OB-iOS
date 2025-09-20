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
    case uploadImage
    case registerProduct
    case carRecommend
    case logout
    case chatList
    case products
    case tokenReissue // 토큰 재발급 요청
    case memberInfo(memberId: String)
    case memberProducts(memberId: String)
    case memberSoldProducts(memberId: String)
    case memberSignout
    case memberNickname
    case memberImage
    case changePassword
    case productInfo

    static let baseURL = "https://campick.shop"

    var path: String {
        switch self {
        case .login: return "/api/member/login"
        case .signup: return "/api/member/signup"
        case .emailSend: return "/api/member/email/send"
        case .emailVerify: return "/api/member/email/verify"
        case .uploadImage: return "/api/product/image"
        case .registerProduct: return "/api/product"
        case .carRecommend: return "/api/product/recommend"
        case .logout: return "/api/member/logout"
        case .chatList: return "/api/chat/my"
        case .products: return "/api/product"
        case .tokenReissue: return "/api/member/reissue"
        case .memberInfo(let memberId): return "/api/member/info/\(memberId)"
        case .memberProducts(let memberId): return "/api/member/product/all/\(memberId)"
        case .memberSoldProducts(let memberId): return "/api/member/sold/\(memberId)"
        case .memberSignout: return "/api/member/signout"
        case .memberNickname: return "/api/member/nickname"
        case .memberImage: return "/api/member/image"
        case .changePassword: return "/api/member/password"
        case .productInfo: return "/api/product/info"
        }
    }

    var url: String { Endpoint.baseURL + path }
}