//
//  AuthInterceptor.swift
//  campick
//
//  Created by oyun on 9/17/25.
//

import Foundation
import Alamofire


// MARK: - 네트워크 요청/응답을 가로채어 공통 처리(토큰 추가, 재시도 등)를 담당하는 Interceptor
final class AuthInterceptor: RequestInterceptor {
    
    // 모든 요청을 서버로 보내기 전에 실행됨 - axios.request.use 같은 역할
    func adapt(
        _ urlRequest: URLRequest, // 원본 요청 객체
        for session: Session, // 현재 Alamofire 세션
        completion: @escaping (Result<URLRequest, Error>) -> Void
    ) {
        var request = urlRequest
        let token = TokenManager.shared.accessToken
        if !token.isEmpty {
            request.setValue("Bearer eyJhbGciOiJIUzI1NiJ9.eyJjYXRlZ29yeSI6ImFjY2VzcyIsImlkIjoxMiwicm9sZSI6IlJPTEVfVVNFUiIsImlhdCI6MTc1ODI1MTIyNSwiZXhwIjoxNzU4MjUzMDI1fQ.ZleO4qro17rHY4K_mE408OwJRpVTLyuKIR9sBfYw2JQ", forHTTPHeaderField: "Authorization")
        }
        completion(.success(request))
    }

    
    // 요청 실패 시(에러 발생) 재시도를 할지 말지 결정하는 메서드
    func retry(
        _ request: Request,
        for session: Session,
        dueTo error: Error,
        completion: @escaping (RetryResult) -> Void
    ) {
        // 현재는 액세스 토큰만 사용하므로 재시도 로직은 비활성화
        completion(.doNotRetry)
    }
}
