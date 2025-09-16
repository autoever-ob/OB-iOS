//
//  CarFirebase.swift
//  campick
//
//  Created by Kihwan Jo on 9/16/25.
//


import FirebaseFirestore

struct CarFirebase: Codable {
    @DocumentID var id: String?  // Firestore 문서 ID
    let brand: String
    let model: String
    let year: Int

    enum CodingKeys: String, CodingKey {
        case brand, model, year
    }

    // 도메인 모델로 변환
    func toDomain() -> Car {
        Car(id: id, brand: brand, model: model, year: year)
    }
}
