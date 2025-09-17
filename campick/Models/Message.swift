//
//  Message.swift
//  campick
//
//  Created by oyun on 2025-09-16.
//

import Foundation

enum MessageType {
    case text
    case image
    case system
}

struct Message:Identifiable, Hashable {
    let id: String;
    let text: String;
    let timestamp: Date;
    let isMyMessage: Bool
    let type: MessageType
}
