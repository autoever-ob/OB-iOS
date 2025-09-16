//
//  ChatView.swift
//  campick
//
//  Created by oyun on 2025-09-16.
//

import SwiftUI

struct ChatView: View {
    let sellerName: String
    let sellerAvatar: String
    
    @State private var messages: [Message] = [
        Message(id: "1", text: "안녕하세요! 현대 포레스트 프리미엄 매물에 관심을 가져주셔서 감사합니다.", timestamp: Date().addingTimeInterval(-30), isMyMessage: false, type: .text),
        Message(id: "2", text: "궁금한 점이 있으시면 언제든 문의해주세요!", timestamp: Date().addingTimeInterval(-25), isMyMessage: false, type: .text),
        Message(id: "3", text: "안녕하세요! 실제로 차량을 보고 싶은데 언제 가능한가요?", timestamp: Date().addingTimeInterval(-20), isMyMessage: true, type: .text)
    ]
    
    @State private var newMessage: String = ""
    
    var body: some View {
        VStack {
            // 헤더
            HStack {
                AsyncImage(url: URL(string: sellerAvatar)) { image in
                    image.resizable()
                }
                placeholder: {
                    Circle().fill(Color.gray)
                }
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                
                VStack(alignment: .leading) {
                    Text(sellerName)
                        .foregroundColor(.white)
                        .font(.headline)
                    Text("온라인")
                        .foregroundColor(.white.opacity(0.6))
                        .font(.caption)
                }
                Spacer()
            }
            .padding()
            .background(Color.black.opacity(0.9))
            
            // 메시지
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(messages) { message in
                        HStack {
                            if message.isMyMessage {
                                Spacer()
                                Text(message.text)
                                    .padding()
                                    .background(Color.orange)
                                    .foregroundColor(.white)
                                    .cornerRadius(12)
                            } else {
                                Text(message.text)
                                    .padding()
                                    .background(Color.white.opacity(0.1))
                                    .foregroundColor(.white)
                                    .cornerRadius(12)
                                Spacer()
                            }
                        }
                    }
                }
                .padding()
            }
            
            // Input
            HStack {
                TextField("메시지를 입력하세요...", text: $newMessage)
                    .padding(10)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(20)
                    .foregroundColor(.white)
                
                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.white)
                        .padding()
                        .background(newMessage.isEmpty ? Color.gray : Color.orange)
                        .clipShape(Circle())
                }
                .disabled(newMessage.isEmpty)
            }
            .padding()
            .background(Color.black.opacity(0.9))
        }
        .background(AppColors.brandBackground)
        .ignoresSafeArea(edges: .bottom)
    }
    
    private func sendMessage() {
        guard !newMessage.isEmpty else { return }
        let msg = Message(id: UUID().uuidString, text: newMessage, timestamp: Date(), isMyMessage: true, type: .text)
        messages.append(msg)
        newMessage = ""
    }
}

#Preview {
    ChatView(sellerName: "송지은", sellerAvatar: "ㅇㅁㄴㅇㄴㅁ")
}
