//
//  APIService.swift
//  campick
//
//  Created by oyun on 9/17/25.
//

import Foundation
import Alamofire


// MARK: - 실제 HTTP 요청을 보내는 역할을 합니다.


// MARK: - 네트워크 요청을 담당하는 공통 APIService
// Alamofire의 Session을 싱글톤(shared)으로 만들어 어디서든 재사용 가능
final class APIService {
    
    // static let shared → 앱 전체에서 하나만 존재하는 공용 세션
    static let shared: Session = {
        // URLSession 기본 설정 가져오기
        let config = URLSessionConfiguration.default
        
        // 요청 타임아웃 시간 설정 (30초)
        config.timeoutIntervalForRequest = 30
        
        // Alamofire의 Session 생성
        // - configuration: 위에서 설정한 URLSessionConfig 사용
        // - interceptor: AuthInterceptor 붙여서 모든 요청/응답을 가로채도록 설정
        return Session(configuration: config, interceptor: AuthInterceptor())
    }()
}
