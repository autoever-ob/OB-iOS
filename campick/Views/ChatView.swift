import SwiftUI

// MARK: - 모델

enum ChatMessageType {
    case text, image, system
}

enum MessageStatus {
    case sent      // 보냄
    case delivered // 서버 전달
    case read      // 상대방 읽음
}

struct ChatMessage: Identifiable, Hashable {
    let id: String
    let text: String
    let timestamp: Date
    let isMyMessage: Bool
    let type: ChatMessageType
    let status: MessageStatus?
    
    init(id: String, text: String, timestamp: Date, isMyMessage: Bool, type: ChatMessageType, status: MessageStatus = .sent) {
            self.id = id
            self.text = text
            self.timestamp = timestamp
            self.isMyMessage = isMyMessage
            self.type = type
            self.status = status
        }
}


struct ChatSeller {
    let id: String
    let name: String
    let avatar: String
    let isOnline: Bool
    let lastSeen: Date?
    let phoneNumber: String
}

struct ChatVehicle {
    let id: String
    let title: String
    let price: Int
    let status: String
    let image: String
}


// MARK: - 타이핑 인디케이터
struct TypingIndicator: View {
    @State private var animate = false
    
    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<3) { i in
                Circle()
                    .fill(Color.gray)
                    .frame(width: 8, height: 8)
                    .offset(y: animate ? -4 : 4)
                    .animation(
                        Animation
                            .easeInOut(duration: 0.6)
                            .repeatForever()
                            .delay(Double(i) * 0.2),
                        value: animate
                    )
            }
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(16)
        .onAppear {
            animate = true
            
        }
    }
}

private struct ViewOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct ChatView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL
    let seller: ChatSeller
    let vehicle: ChatVehicle
    
    @State private var messages: [ChatMessage] = [
        ChatMessage(id: "1", text: "안녕하세요! 현대 포레스트 프리미엄 매물에 관심을 가져주셔서 감사합니다.", timestamp: Date().addingTimeInterval(-30), isMyMessage: false, type: .text),
        ChatMessage(id: "2", text: "궁금한 점이 있으시면 언제든 문의해주세요!", timestamp: Date().addingTimeInterval(-25), isMyMessage: false, type: .text),
        ChatMessage(id: "3", text: "안녕하세요! 실제로 차량을 보고 싶은데 언제 가능한가요?", timestamp: Date().addingTimeInterval(-20), isMyMessage: true, type: .text, status: .read),
        ChatMessage(id: "4", text: "네, 언제든 가능합니다! 평일 오전 10시부터 오후 6시까지 가능하고, 주말도 가능해요.", timestamp: Date().addingTimeInterval(-15), isMyMessage: false, type: .text),
        ChatMessage(id: "5", text: "잠시만요. 제가 지금 바빠서요. 잠시만 기다려주세요.", timestamp: Date().addingTimeInterval(-15), isMyMessage: true, type: .text, status: .read),
        ChatMessage(id: "6", text: "네.", timestamp: Date().addingTimeInterval(-15), isMyMessage: false, type: .text),
        ChatMessage(id: "7", text: "저기요.", timestamp: Date().addingTimeInterval(-15), isMyMessage: false, type: .text),
        ChatMessage(id: "8", text: "판매 완료했어요.", timestamp: Date().addingTimeInterval(-15), isMyMessage: false, type: .text)
    ]
    
    @State private var newMessage: String = ""
    @State private var isTyping: Bool = false
    @State private var isAtBottom: Bool = true
    @State private var didEnterInitially = false
    @State private var showCallAlert = false
    private let bottomThreshold: CGFloat = 40

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - 헤더
            VStack(spacing: 0) {
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.white.opacity(0.1))
                            .clipShape(Circle())
                    }
                    
                    Image("park")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(seller.name)
                            .foregroundColor(.white)
                            .font(.headline)
                        HStack {
                            Circle()
                                .fill(seller.isOnline ? Color.green : Color.gray)
                                .frame(width: 8, height: 8)
                            Text(seller.isOnline ? "온라인" : formatTime(seller.lastSeen ?? Date()))
                                .foregroundColor(.white.opacity(0.6))
                                .font(.caption)
                        }
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 12) {
                        Button {
                            callSeller()
                        } label: {
                            Image(systemName: "phone")
                                .foregroundColor(.white)
                                .padding(10)
                                .background(Color.white.opacity(0.1))
                                .clipShape(Circle())
                        }
                        .disabled(URL(string: "tel://\(seller.phoneNumber)") == nil)
                    }
                }
                .padding()
                .background(AppColors.brandBackground)
                
                // MARK: - 매물 정보
                HStack {
                    Image("testImage1")
                        .resizable()
                        .frame(width: 60, height: 45)
                        .cornerRadius(8)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(vehicle.status)
                            .font(.system(size: 11, weight: .heavy))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        
                        Text(vehicle.title)
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .heavy))
                            .lineLimit(1)
                        
                        Text("\(vehicle.price)만원")
                            .foregroundColor(.orange)
                            .font(.system(size: 12, weight: .bold))
                            .bold()
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .foregroundColor(.white.opacity(0.6))
                }
                .padding([.horizontal, .bottom])
            }
            .background(
                AppColors.brandBackground
                //                    .ignoresSafeArea(edges: .bottom)
                    .overlay(
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 1),
                        alignment: .bottom
                    )
            )
            
            // MARK: - 메시지 영역
            ZStack {
                // GeometryReader : 좌표 공간을 기준으로 위치, 크기 계산 가능 -> 스크롤 뷰의 위치 추적
                GeometryReader { outerGeo in
                    ScrollViewReader { proxy in
                        ScrollView {
                            VStack(spacing: 12) {
                                ForEach(messages) { msg in
                                    HStack {
                                        if msg.isMyMessage {
                                            Spacer()
                                            VStack(alignment: .trailing) {
                                                Text(msg.text)
                                                    .padding()
                                                    .background(AppColors.brandOrange)
                                                    .foregroundColor(.white)
                                                    .cornerRadius(16)
                                                HStack(spacing: 4) {
                                                    Text(formatTime(msg.timestamp))
                                                        .foregroundColor(.white.opacity(0.5))
                                                        .font(.caption2)
                                                    if msg.id == messages.last(where: { $0.isMyMessage })?.id {
                                                        MessageStatusView(status: msg.status ?? .sent,
                                                                          timestamp: msg.timestamp)
                                                    }
                                                }
                                            }
                                            .frame(maxWidth: 300, alignment: .trailing)
                                        } else {
                                            Image("bannerImage",bundle: nil)
                                                .resizable()
                                                .frame(width: 40, height: 40)
                                                .clipShape(Circle())
                                                .padding(.bottom,60)
                                            VStack(alignment: .leading) {
                                                Text(msg.text)
                                                    .padding()
                                                    .background(.ultraThinMaterial.opacity(0.2))
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 16)
                                                            .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                                                    )
                                                    .foregroundColor(.white)
                                                    .cornerRadius(16)
                                                Text(formatTime(msg.timestamp))
                                                    .foregroundColor(.white.opacity(0.5))
                                                    .font(.caption2)
                                            }
                                            .frame(maxWidth: 300, alignment: .leading)
                                            Spacer()
                                        }
                                    }
                                    .id(msg.id)
                                }
                                Color.clear
                                    .frame(height: 1)
                                    .id("bottom-anchor")
                                    .background(
                                        // 좌표 공간을 기준으로 위치, 크기 계산 가능 -> 스크롤 뷰의 위치 추적
                                        GeometryReader { geo in
                                            Color.clear
                                                .preference(key: ViewOffsetKey.self, value: geo.frame(in: .named("scroll")).maxY)
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
                            .onChange(of: messages.count) { _, newValue in
                                withAnimation {
                                    proxy.scrollTo(messages.last?.id, anchor: .bottom)
                                }
                            }
                            .onChange(of: messages.last?.id) { _, _ in
                                DispatchQueue.main.async {
                                    isAtBottom = true
                                }
                            }
                        }
                        .coordinateSpace(name: "scroll")
                        // 좌표 공간을 기준으로 위치, 크기 계산 가능 -> 스크롤 뷰의 위치 추적
                        .onPreferenceChange(ViewOffsetKey.self) { bottomMaxY in
                            let visibleBottom = outerGeo.frame(in: .local).maxY
                            let adjustedVisibleBottom = visibleBottom + 22
                            let distance = adjustedVisibleBottom - bottomMaxY
                            withAnimation(.easeInOut(duration: 0.2)) {
                                isAtBottom = distance >= 0 && distance <= bottomThreshold
                            }
                        }
                        .onAppear {
                            DispatchQueue.main.async {
                                if let lastId = messages.last?.id {
                                    proxy.scrollTo(lastId, anchor: .bottom)
                                } else {
                                    proxy.scrollTo("bottom-anchor", anchor: .bottom)
                                }
                                
                                DispatchQueue.main.async {
                                    if let lastId = messages.last?.id {
                                        proxy.scrollTo(lastId, anchor: .bottom)
                                    } else {
                                        proxy.scrollTo("bottom-anchor", anchor: .bottom)
                                    }
                                }
                            }
                        }
                        .simultaneousGesture(DragGesture().onChanged { _ in
                            isAtBottom = false
                        })
                        .overlay(alignment: .bottomTrailing) {
                            if messages.count >= 6 && !isAtBottom {
                                Button {
                                    withAnimation {
                                        proxy.scrollTo("bottom-anchor", anchor: .bottom)
                                    }
                                    DispatchQueue.main.async {
                                        withAnimation(.easeInOut(duration: 0.01)) {
                                            isAtBottom = true
                                        }
                                    }
                                } label: {
                                    Image(systemName: "arrow.down")
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
                        .animation(.easeInOut(duration: 0.2), value: isAtBottom)
                    }
                    .onAppear{
                        isAtBottom = true
                    }
                }
            }
            .background(AppColors.brandBackground)
            
            
            // MARK: - 입력창
            HStack {
                Button {
                    
                } label: {
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                        .padding(13)
                        .background(Color.white.opacity(0.1))
                        .clipShape(Circle())
                }
                
                TextField("메시지를 입력하세요...", text: $newMessage, onCommit: sendMessage)
                    .padding(10)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(20)
                    .foregroundColor(.white)
                
                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.white)
                        .padding(10)
                        .background(newMessage.isEmpty ? Color.white.opacity(0.2) : AppColors.brandOrange)
                        .clipShape(Circle())
                }
                .disabled(newMessage.isEmpty)
            }
            .padding()
            .background(
                AppColors.brandBackground
                    .ignoresSafeArea(edges: .bottom)
                    .overlay(
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 1),
                        alignment: .top
                    )
            )
        }
        .alert("실기기에서만 동작합니다", isPresented: $showCallAlert) {
            Button("확인", role: .cancel) { }
        }
        .ignoresSafeArea(edges: .bottom)
    }
    
    // MARK: - 메서드
    private func sendMessage() {
        guard !newMessage.isEmpty else { return }
        let msg = ChatMessage(id: UUID().uuidString, text: newMessage, timestamp: Date(), isMyMessage: true, type: .text)
        messages.append(msg)
        newMessage = ""
        
        // 응답 시뮬레이션
        isTyping = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let response = ChatMessage(id: UUID().uuidString, text: "네, 알겠습니다!", timestamp: Date(), isMyMessage: false, type: .text)
            messages.append(response)
            isTyping = false
        }
    }
    
    private func callSeller() {
        let rawNumber = seller.phoneNumber.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let url = URL(string: "tel://\(rawNumber)") else { return }
    #if targetEnvironment(simulator)
        showCallAlert = true
    #else
        openURL(url)
    #endif
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}

struct MessageStatusView: View {
    let status: MessageStatus
    let timestamp: Date
    
    var body: some View {
        HStack(spacing: 4) {
//            Text(formatTime(timestamp))
//                .foregroundColor(.white.opacity(0.5))
//                .font(.caption2)
            
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
                Image(systemName: "checkmark")
                    .foregroundColor(AppColors.brandLightGreen)
                    .font(.caption2)
                    .padding(.bottom,2)
            }
        }
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}

// MARK: - Preview
#Preview {
    ChatView(
        seller: ChatSeller(id: "1", name: "박우진", avatar: "tiffany", isOnline: true, lastSeen: Date(),phoneNumber: "010-1234-1234"),
        vehicle: ChatVehicle(id: "1", title: "현대 포레스트 프리미엄", price: 8900, status: "판매중", image: "https://picsum.photos/200/120?random=3")
    )
}

