//
//  ChatResponse.swift
//  campick
//
//  Created by Admin on 9/23/25.
//

import Foundation

struct ChatResponse: Decodable {
    let totalElements: Int
    let totalPages: Int
    let page: Int
    let size: Int
    let sellerId: Int
    let buyerId: Int
    let sellerNickname: String
    let buyerNickname: String
    let sellerProfileImage: String?
    let sellerPhoneNumber: String
    let productId: Int
    let productTitle: String
    let productImage: String?
    let productStatus: String
    let productPrice: String
    let isActive: Bool
    let chatData: [Chat]
    let last: Bool
}
