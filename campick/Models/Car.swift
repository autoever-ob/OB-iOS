//
//  Car.swift
//  campick
//
//  Created by Kihwan Jo on 9/16/25.
//


struct Car: Identifiable {
    let id: String?  // ID는 옵셔널로, 플랫폼에 따라 생성 여부 달라짐
    let brand: String
    let model: String
    let year: Int
}