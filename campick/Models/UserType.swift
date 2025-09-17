//
//  UserType.swift
//  campick
//
//  Created by Admin on 9/17/25.
//

import Foundation

public enum UserType: String, Codable, Hashable, CaseIterable, Identifiable, Sendable {
    case normal
    case dealer

    public var id: String { rawValue }

    /// A localized, user-facing title for display in the UI.
    public var title: String {
        switch self {
        case .normal: return "일반 사용자"
        case .dealer: return "딜러"
        }
    }
}
