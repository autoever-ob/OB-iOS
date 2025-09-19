//
//  WebSocket.swift
//  campick
//
//  Created by Admin on 9/19/25.
//

import Foundation

class WebSocket {
    private var webSocketTask: URLSessionWebSocketTask?
    
    func connect(userId: String) {
        guard let url = URL(string: "wss://campick.shop/ws/\(userId)") else { return }
        let urlSession = URLSession(configuration: .default)
        webSocketTask = urlSession.webSocketTask(with: url)
        webSocketTask?.resume()
        
        print("웹소켓 연결 시도")
        
        // 연결 후 수신 시작
        receive()
    }
    
    private func receive() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .failure(let error):
                print("수신 실패:", error)
            case .success(let message):
                switch message {
                case .string(let text):
                    print("받은 메시지:", text)
                case .data(let data):
                    print("바이너리 데이터:", data)
                @unknown default:
                    break
                }
            }
            
            // 계속 대기
            self?.receive()
        }
    }
    
    func send(_ text: String) {
        webSocketTask?.send(.string(text)) { error in
            if let error = error {
                print("전송 실패:", error)
            } else {
                print("전송 성공:", text)
            }
        }
    }
    
    func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        print("웹소켓 연결 해제")
    }
}
