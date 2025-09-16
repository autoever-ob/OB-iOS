//
//  CarSpring.swift
//  campick
//
//  Created by Kihwan Jo on 9/16/25.
//


struct CarSpring: Codable {
    let id: String?  // Spring Boot에서 ID 제공 여부에 따라 조정
    let brand: String
    let model: String
    let year: Int

    // 도메인 모델로 변환
    func toDomain() -> Car {
        Car(id: id, brand: brand, model: model, year: year)
    }
}