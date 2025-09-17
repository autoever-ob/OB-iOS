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
        // Authorization 헤더에 Access Token 자동 추가
        request.setValue("Bearer \(TokenManager.shared.accessToken)", forHTTPHeaderField: "Authorization")
        completion(.success(request))
    }

    
    // 요청 실패 시(에러 발생) 재시도를 할지 말지 결정하는 메서드
    func retry(
        _ request: Request,
        for session: Session,
        dueTo error: Error,
        completion: @escaping (RetryResult) -> Void
    ) {
        if let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 {
            // 토큰 만료 → refreshToken 실행 ( 미구현 상태 )
            TokenManager.shared.refreshToken { success in
                if success {
                    // 토큰 갱신 성공 시 → 동일 요청을 다시 시도
                    completion(.retry)
                } else {
                    // 토큰 갱신 실패 시 → 재시도하지 않고 에러 그대로 반환
                    completion(.doNotRetry)
                }
            }
        } else {
            // 401 이외의 에러는 그냥 재시도하지 않음
            completion(.doNotRetry)
        }
    }
}
