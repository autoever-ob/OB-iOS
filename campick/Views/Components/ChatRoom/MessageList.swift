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
    @ObservedObject var viewModel: ChatViewModel
    @State private var isAtBottom: Bool = true
    private let bottomThreshold: CGFloat = 80
    @State private var didScrollToBottomInitially = false
    @State private var scrollProxy: ScrollViewProxy?
    @State private var containerMaxY: CGFloat = .zero
    
    let chatRoomId: Int
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(spacing: 12) {
//                    ForEach(viewModel.messages) { msg in
//                        MessageBubble(
//                            message: msg,
//                            viewModel: viewModel
//                        )
//                        .id(msg.id)
//                    }
                    // MARK: - 기존 채팅 리스트 렌더링
//                    ForEach(Array(viewModel.messages.enumerated()), id: \.1.id) { index, msg in
//                        let isLast = index == viewModel.messages.count - 1
//                        MessageBubble(
//                            message: msg,
//                            isLast: isLast,
//                            viewModel: viewModel
//                            
//                        )
//                        .id(msg.id)
//                    }
                    
                    // MARK: - 페이지네이션 채팅 리스트 렌더링
                    var orderedMessages: [Chat] {
                        viewModel.messages.sorted { $0.sendAt < $1.sendAt }
                    }
                    ForEach(Array(viewModel.messages.enumerated()), id: \.1.id) { index, msg in
                        MessageBubble(
                            message: msg,
                            isLast: msg.id == viewModel.messages.last?.id,
                            viewModel: viewModel
                        )
                        .id(msg.id)
                        .onAppear {
                            if index == 0 && !viewModel.isLoading {
                                viewModel.loadChatRoom(chatRoomId: chatRoomId, reset: false)
                            }
                        }
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
                    
//                    if viewModel.isTyping {
//                        HStack {
//                            TypingIndicator()
//                            Spacer()
//                        }
//                    }
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
//            .onAppear {
//                scrollProxy = proxy
//                guard !didScrollToBottomInitially else { return }
//                didScrollToBottomInitially = true
//                scrollToBottom(proxy: proxy, animated: false)
//                
//            }
            .onAppear {
                scrollProxy = proxy
                // 진입 시 최초 스크롤: 맨 위
                if let firstId = viewModel.messages.first?.id {
                    proxy.scrollTo(firstId, anchor: .top)
                }
            }

            .onChange(of: viewModel.messages.count) { _, _ in
                // 이후 새 메시지 추가되면 맨 아래로
                if let lastId = viewModel.messages.last?.id {
                    withAnimation(.easeInOut) {
                        proxy.scrollTo(lastId, anchor: .bottom)
                    }
                }
            }
            .onChange(of: viewModel.messages.count) { _, _ in
                scrollToBottom(proxy: proxy, animated: true)
            }
//            .onChange(of: viewModel.isTyping) { _, _ in
//                if viewModel.isTyping && isAtBottom {
//                    withAnimation(.easeInOut) {
//                        proxy.scrollTo("bottom-anchor", anchor: .bottom)
//                    }
//                }
//            }
//            .onChange(of: viewModel.messages) { _, newMessages in
//                guard let last = newMessages.last else { return }
//                if last.isMyMessage {
//                    scrollToBottom(proxy: proxy, animated: true)
//                } else if isAtBottom {
//                    scrollToBottom(proxy: proxy, animated: true)
//                }
//            }
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
        .overlay(alignment: .bottomTrailing) {
            if !isAtBottom {
                Button {
                    if let proxy = scrollProxy {
                        withAnimation(.easeInOut) {
                            proxy.scrollTo("bottom-anchor", anchor: .bottom)
                        }
                    }
                } label: {
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
    let message: Chat
    let isLast: Bool
    @ObservedObject var viewModel: ChatViewModel
    
    var body: some View {
        HStack {
            if viewModel.isMyMessage(message) {
                Spacer()
                VStack(alignment: .trailing) {
                    if let url = URL(string: message.message),
                       message.message.hasPrefix("http") {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(width: 200, height: 200)
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxWidth: 200, maxHeight: 200)
                                    .cornerRadius(12)
                            case .failure:
                                Text("이미지를 불러올 수 없습니다")
                                    .foregroundColor(.red)
                            @unknown default:
                                EmptyView()
                            }
                        }
                    } else {
                        Text(message.message)
                            .padding()
                            .background(AppColors.brandOrange)
                            .foregroundColor(.white)
                            .cornerRadius(16)
                    }

                    if isLast {
                        HStack(spacing: 4) {
                            Text(message.sendAt)
                                .foregroundColor(.white.opacity(0.5))
                                .font(.caption2)
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
                    if let url = URL(string: message.message),
                       message.message.hasPrefix("http") {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(width: 200, height: 200)
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(maxWidth: 200, maxHeight: 200)
                                    .cornerRadius(12)
                            case .failure:
                                Text("이미지를 불러올 수 없습니다")
                                    .foregroundColor(.red)
                            @unknown default:
                                EmptyView()
                            }
                        }
                    } else {
                        Text(message.message)
                            .padding()
                            .background(.ultraThinMaterial.opacity(0.2))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                            )
                            .foregroundColor(.white)
                            .cornerRadius(16)
                    }
                    
                    if isLast {
                        HStack(spacing: 4) {
                            Text(message.sendAt)
                                .foregroundColor(.white.opacity(0.5))
                                .font(.caption2)
                        }
                    }
                }
                
                .frame(maxWidth: 300, alignment: .leading)
                .padding(.vertical, 4)
            }
        }
    }
}
