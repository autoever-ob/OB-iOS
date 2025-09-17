//
//  Endpoints.swift
//  campick
//
//  Created by oyun on 9/17/25.
//

 
// MARK: - API 주소를 정의하는 곳입니다.
import Foundation
enum Endpoint: String {
    case login = "/auth/login"
    case userInfo = "/user/info"
    case carInfo = "/car/info"

    var url: String {
        "https://cam-pick.com/" + rawValue
    }
}

// 🚨 사용 예시
//APIService.shared.request(Endpoint.userInfo.url) // 👉 GET https://api.example.com/user/info
//    .validate() // 200~299 응답만 success로 처리
//    .responseDecodable(of: User.self) { response in
//        switch response.result {
//        case .success(let user):
//            print("✅ 유저 정보 로드 성공")
//            print("ID: \(user.id), 이름: \(user.name), 이메일: \(user.email)")
//            
//        case .failure(let error):
//            print("❌ 유저 정보 로드 실패: \(error.localizedDescription)")
//        }
//    }
