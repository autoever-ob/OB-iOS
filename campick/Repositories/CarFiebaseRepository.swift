//
//  CarFiebaseRepository.swift
//  campick
//
//  Created by Kihwan Jo on 9/16/25.
//

import FirebaseFirestore

class CarFirebaseRepository: CarRepositoryProtocol {
    private let db = Firestore.firestore()
    private let collectionPath = "cars"

    func fetchCars() async throws -> [Car] {
        let snapshot = try await db.collection(collectionPath).getDocuments()
        return try snapshot.documents.compactMap { document in
            let carFirebase = try document.data(as: CarFirebase.self)
            return carFirebase.toDomain()
        }
    }
}
