//
//  ChatList.swift
//  campick
//
//  Created by Admin on 9/19/25.
//

import Foundation


struct ChatRoom: Identifiable,Hashable {
    let id: Int
    let sellerId: String
    let sellerName: String
    let sellerAvatar: String
    let vehicleId: String
    let vehicleTitle: String
    let vehicleImage: String
    let lastMessage: String
    let lastMessageTime: Date
    let unreadCount: Int
    let isOnline: Bool
    
    enum CodingKeys: String, CodingKey {
            case chatRoomId = "id"
            case sellerId
            case sellerName = "nickname"
            case sellerAvatar = "profileImage"
            case vehicleId
            case vehicleTitle = "productName"
            case vehicleImage = "productThumbnail"
            case lastMessage
            case lastMessageTime = "lastMessageCreatedAt"
            case unreadCount = "unreadMessage"
            case isOnline = "isActive"
        }
}
