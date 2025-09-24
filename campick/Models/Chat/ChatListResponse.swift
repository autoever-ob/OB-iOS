//
//  ChatListResponse.swift
//  campick
//
//  Created by Admin on 9/19/25.
//

import Foundation

// MARK: 기존 채팅리스트 응답
//struct ChatListResponse: Decodable {
//    let chatRoom: [ChatList]
//    let totalUnreadMessage: Int
//}

// MARK: 페이지네이션 채팅리스트 응답
struct ChatListResponse: Decodable {
    let totalElements: Int
    let totalPages: Int
    let page: Int
    let size: Int
    let totalUnreadMessage: Int
    let content: [ChatList]
    let last: Bool
}
