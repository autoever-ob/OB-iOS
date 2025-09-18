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

private struct BottomAnchorPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

private struct ContainerBottomPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct MessageList: View {
    @Binding var messages: [ChatMessage]
    @Binding var isTyping: Bool
    @State private var isAtBottom: Bool = true
    private let bottomThreshold: CGFloat = 80
    @State private var didScrollToBottomInitially = false
    @State private var scrollProxy: ScrollViewProxy?
    @State private var containerMaxY: CGFloat = .zero

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
                    Color.clear
                        .frame(height: 1)
                        .id("bottom-anchor")
                        .background(
                            GeometryReader { geo in
                                Color.clear
                                    .preference(
                                        key: BottomAnchorPreferenceKey.self,
                                        value: geo.frame(in: .named("scroll")).maxY
                                    )
                            }
                        )

                    if isTyping {
                        HStack {
                            TypingIndicator()
                            Spacer()
                        }
                    }
                }
                .padding()
            }
            .overlay(
                GeometryReader { geo in
                    Color.clear
                        .preference(
                            key: ContainerBottomPreferenceKey.self,
                            value: geo.frame(in: .named("scroll")).maxY
                        )
                }
            )
            .coordinateSpace(name: "scroll")
            .onAppear {
                scrollProxy = proxy
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
            .onPreferenceChange(ContainerBottomPreferenceKey.self) { value in
                containerMaxY = value
            }
            .onPreferenceChange(BottomAnchorPreferenceKey.self) { bottomMaxY in
                let distance = containerMaxY - bottomMaxY
                withAnimation(.easeInOut(duration: 0.2)) {
                    isAtBottom = distance >= 0 && distance <= bottomThreshold
                }
            }
        }
        .overlay(alignment: .bottomTrailing,
            content: {
            Group {
                if !isAtBottom {
                    Button(action: {
                        if let proxy = scrollProxy {
                            withAnimation(.easeInOut) {
                                proxy.scrollTo("bottom-anchor", anchor: .bottom)
                            }
                        }
                    }) {
                        Image(systemName: "arrow.down.circle.fill")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(12)
                            .background(AppColors.brandOrange.opacity(0.8))
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 2)
                    }
                    .padding(.trailing, 16)
                    .padding(.bottom, 16)
                    .transition(.opacity.combined(with: .scale))
                }
            }
            .animation(.easeInOut, value: isAtBottom)
        })
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

