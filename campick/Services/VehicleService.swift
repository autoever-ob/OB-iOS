//
//  VehicleService.swift
//  campick
//
//  Created by Admin on 9/19/25.
//

import Foundation
import Alamofire

class VehicleService: ObservableObject {
    static let shared = VehicleService()
    
    private init() {}
    
    private lazy var decoder: JSONDecoder = {
        let d = JSONDecoder()
        d.keyDecodingStrategy = .convertFromSnakeCase
        return d
    }()
    
    func getRecommendVehicles(completion: @escaping (Result<[Vehicle], AFError>) -> Void) {
            APIService.shared
            .request(Endpoint.carRecommend.url)
                .validate()
                .responseDecodable(of: [Vehicle].self, decoder: decoder) { response in
                    switch response.result {
                    case .success(let vehicles):
                        print("✅ 차량 목록 로드 성공")
                        completion(.success(vehicles))
                    case .failure(let error):
                        print("❌ 차량 목록 로드 실패: \(error.localizedDescription)")
                        completion(.failure(error))
                    }
                }
        }
}
