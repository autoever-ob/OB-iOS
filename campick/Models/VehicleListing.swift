//
//  VehicleListing.swift
//  campick
//
//  Created by 김호집 on 9/16/25.
//

import SwiftUI

struct VehicleListing {
    let id: String
    let title: String
    let image: String
    let price: Int
    let year: Int
    let mileage: Int
    let status: VehicleStatus
    let location: String
    let postedDate: String
}

enum VehicleStatus: String, CaseIterable {
    case active = "active"
    case reserved = "reserved"
    case sold = "sold"

    var displayText: String {
        switch self {
        case .active: return "판매중"
        case .reserved: return "예약중"
        case .sold: return "판매완료"
        }
    }

    var color: Color {
        switch self {
        case .active: return .green
        case .reserved: return .orange
        case .sold: return .gray
        }
    }
}