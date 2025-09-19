//
//  HomeChatViewModel.swift
//  campick
//
//  Created by Admin on 9/19/25.
//

import Foundation

final class HomeChatViewModel: ObservableObject {
    private let socket = WebSocket()
    
    func connectWebSocket(userId: String) {
            socket.connect(userId: userId)
        }

        func disconnectWebSocket() {
            socket.disconnect()
        }

        func sendMessage(_ text: String) {
            socket.send(text)
        }
}
