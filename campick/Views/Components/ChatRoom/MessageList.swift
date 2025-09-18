//
//  MessageList.swift
//  campick
//
//  Created by Admin on 9/18/25.
//

import SwiftUI

private struct ViewOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct MessageList: View {
    @Binding var messages: [ChatMessage]
    @Binding var isTyping: Bool
    @Binding var isAtBottom: Bool
    let bottomThreshold: CGFloat
    @State private var didScrollToBottomInitially = false

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(messages) { msg in
                        MessageBubble(
                            message: msg,
                            isLastMyMessage: msg.id == messages.last(where: { $0.isMyMessage })?.id
                        )
                        .id(msg.id)
                    }

                    // 바닥 앵커
                    Color.clear.frame(height: 1).id("bottom-anchor")

                    if isTyping {
                        HStack {
                            TypingIndicator()
                            Spacer()
                        }
                    }
                }
                .padding()
                // 현재 스크롤의 바닥 여유를 측정해서 isAtBottom 업데이트
                .background(
                    GeometryReader { geo in
                        Color.clear
                            .preference(key: ViewOffsetKey.self, value: geo.frame(in: .named("scroll")).maxY)
                    }
                )
            }
            .coordinateSpace(name: "scroll")
            .onAppear {
                // 처음 진입 시 1회만 바닥으로 스크롤
                guard !didScrollToBottomInitially else { return }
                didScrollToBottomInitially = true
                scrollToBottom(proxy: proxy, animated: false)
            }
            .onChange(of: messages.count) { _, _ in
                // 새로운 메시지가 추가되고 사용자가 바닥에 있을 때만 따라 내려가기
                if isAtBottom {
                    scrollToBottom(proxy: proxy, animated: true)
                }
            }
            .onChange(of: isTyping) { _, _ in
                // 타이핑 인디케이터가 나타날 때 바닥에 있으면 유지
                if isTyping && isAtBottom {
                    withAnimation(.easeInOut) {
                        proxy.scrollTo("bottom-anchor", anchor: .bottom)
                    }
                }
            }
            .onPreferenceChange(ViewOffsetKey.self) { _ in
                // 바닥 여부 판단을 위해 스크롤 위치를 업데이트
                // 간단한 방식: 항상 마지막 메시지로 스크롤했을 때는 바닥이라고 가정
                // 더 정교한 계산이 필요하면 스크롤 오프셋 계산 로직을 추가하세요.
            }
        }
    }

    private func scrollToBottom(proxy: ScrollViewProxy, animated: Bool) {
        if animated {
            withAnimation(.easeInOut) {
                proxy.scrollTo("bottom-anchor", anchor: .bottom)
            }
        } else {
            proxy.scrollTo("bottom-anchor", anchor: .bottom)
        }
    }
}


struct MessageBubble: View {
    let message: ChatMessage
    let isLastMyMessage: Bool
    
    var body: some View {
        HStack {
            if message.isMyMessage {
                Spacer()
                VStack(alignment: .trailing) {
                    if let img = message.image, message.type == .image {
                        VStack(alignment: .trailing, spacing: 4) {
                            Image(uiImage: img)
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: 240, maxHeight: 240)
                                .clipped()
                                .cornerRadius(16)
                            if !message.text.isEmpty {
                                Text(message.text)
                                    .padding()
                                    .background(AppColors.brandOrange)
                                    .foregroundColor(.white)
                                    .cornerRadius(16)
                            }
                        }
                    } else {
                        Text(message.text)
                            .padding()
                            .background(AppColors.brandOrange)
                            .foregroundColor(.white)
                            .cornerRadius(16)
                    }
                    HStack(spacing: 4) {
                        Text(formatTime(message.timestamp))
                            .foregroundColor(.white.opacity(0.5))
                            .font(.caption2)
                        if isLastMyMessage {
                            MessageStat(status: message.status ?? .sent,
                                              timestamp: message.timestamp)
                        }
                    }
                }
                .frame(maxWidth: 300, alignment: .trailing)
            } else {
                Image("bannerImage")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                VStack(alignment: .leading) {
                    if let img = message.image, message.type == .image {
                        VStack(alignment: .leading, spacing: 6) {
                            Image(uiImage: img)
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: 240, maxHeight: 240)
                                .clipped()
                                .cornerRadius(16)
                            if !message.text.isEmpty {
                                Text(message.text)
                                    .padding()
                                    .background(.ultraThinMaterial.opacity(0.2))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                                    )
                                    .foregroundColor(.white)
                                    .cornerRadius(16)
                            }
                        }
                    } else {
                        Text(message.text)
                            .padding()
                            .background(.ultraThinMaterial.opacity(0.2))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                            )
                            .foregroundColor(.white)
                            .cornerRadius(16)
                    }
                }
                .frame(maxWidth: 300, alignment: .leading)
                Spacer()
            }
        }
        
        .padding(.vertical, 4)
    }
    
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}
struct MessageStat: View {
    let status: MessageStatus
    let timestamp: Date
    
    var body: some View {
        switch status {
        case .sent:
            Image(systemName: "checkmark")
                .foregroundColor(.gray)
                .font(.caption2)
        case .delivered:
            Image(systemName: "checkmark")
                .foregroundColor(.white.opacity(0.6))
                .font(.caption2)
        case .read:
            Image(systemName: "checkmark.double")
                .foregroundColor(.blue)
                .font(.caption2)
        }
    }
}
