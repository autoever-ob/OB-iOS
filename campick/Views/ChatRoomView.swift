import SwiftUI
import PhotosUI


// MARK: - 모델

enum ChatMessageType {
    case text, image, system
}

enum MessageStatus {
    case sent
    case delivered
    case read
}

struct ChatMessage: Identifiable, Hashable {
    let id: String
    let text: String
    let image: UIImage?
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
        self.image = nil
    }
    
    init(id: String, image: UIImage, timestamp: Date, isMyMessage: Bool, type: ChatMessageType, status: MessageStatus = .sent) {
        self.id = id
        self.text = ""
        self.image = image
        self.timestamp = timestamp
        self.isMyMessage = isMyMessage
        self.type = type
        self.status = status
    }
    
    init(id: String, text: String, image: UIImage, timestamp: Date, isMyMessage: Bool, type: ChatMessageType, status: MessageStatus = .sent) {
        self.id = id
        self.text = text
        self.image = image
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

struct ChatRoomView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.openURL) private var openURL
    
    
    let seller: ChatSeller
    let vehicle: ChatVehicle
    var onBack: (() -> Void)? = nil
    
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
    
    @State private var showAttachmentMenu = false
    @State private var showImagePicker = false
    @State private var showCamera = false
    @State private var selectedImage: UIImage? = nil
    @State private var pendingImage: UIImage? = nil
    @State private var keyboardHeight: CGFloat = 0
    
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
                    
                    Image("testImage1")
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
                                                if let img = msg.image, msg.type == .image {
                                                    VStack(alignment: .trailing, spacing: 4) {
                                                        Image(uiImage: img)
                                                            .resizable()
                                                            .scaledToFill()
                                                            .frame(maxWidth: 240, maxHeight: 240)
                                                            .clipped()
                                                            .cornerRadius(16)
                                                        if !msg.text.isEmpty {
                                                            Text(msg.text)
                                                                .padding()
                                                                .background(AppColors.brandOrange)
                                                                .foregroundColor(.white)
                                                                .cornerRadius(16)
                                                        }
                                                    }
                                                } else {
                                                    Text(msg.text)
                                                        .padding()
                                                        .background(AppColors.brandOrange)
                                                        .foregroundColor(.white)
                                                        .cornerRadius(16)
                                                }
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
                                            VStack(alignment: .leading) {
                                                if let img = msg.image, msg.type == .image {
                                                    VStack(alignment: .leading, spacing: 6) {
                                                        // 이미지 단독 (테두리/버블 없이)
                                                        Image(uiImage: img)
                                                            .resizable()
                                                            .scaledToFill()
                                                            .frame(maxWidth: 240, maxHeight: 240)
                                                            .clipped()
                                                            .cornerRadius(16)
                                                        // 캡션이 있으면 텍스트 버블만 별도로
                                                        if !msg.text.isEmpty {
                                                            Text(msg.text)
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
                                                    Text(msg.text)
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
                        .onChange(of: pendingImage) { _, newValue in
                            guard newValue != nil else { return }
                            
                            withAnimation {
                                proxy.scrollTo("bottom-anchor", anchor: .bottom)
                            }
                            DispatchQueue.main.async {
                                withAnimation(.easeInOut(duration: 0.01)) {
                                    isAtBottom = true
                                }
                            }
                        }
                        .onChange(of: keyboardHeight) { _, newValue in
                            guard newValue > 0 else { return }
                            
                            if isAtBottom {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                                    withAnimation {
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
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.9)) {
                        showAttachmentMenu.toggle()
                    }
                } label: {
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                        .padding(13)
                        .background(Color.white.opacity(0.1))
                        .clipShape(Circle())
                }
                
                TextField("메시지를 입력하세요...", text: $newMessage)
                    .submitLabel(.send)
                    .onSubmit { sendMessage() }
                    .padding(10)
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(20)
                    .foregroundColor(.white)
                
                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.white)
                        .padding(10)
                        .background((newMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && pendingImage == nil) ? Color.white.opacity(0.2) : AppColors.brandOrange)
                        .clipShape(Circle())
                }
                .disabled(newMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && pendingImage == nil)
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
        .padding(.bottom, keyboardHeight)
        .animation(.easeInOut(duration: 0.25), value: keyboardHeight)
        .overlay(alignment: .bottomLeading) {
            if let preview = pendingImage {
                HStack(spacing: 12) {
                    ZStack(alignment: .topTrailing) {
                        Image(uiImage: preview)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .clipped()
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                            )
                            .allowsHitTesting(false)
                        Button {
                            withAnimation { pendingImage = nil }
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                                .background(Color.black.opacity(0.4))
                                .clipShape(Circle())
                        }
                        .offset(x: 6, y: -6)
                    }
                }
                
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .background(.clear)
                .offset(x: 0, y: -80)
            }
            
        }
        .overlay(alignment: .bottomLeading) {
            if showAttachmentMenu {                ZStack(alignment: .bottomLeading) {
                Color.black.opacity(0.35)
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.9)) {
                            showAttachmentMenu = false
                        }
                    }
                
                VStack(alignment: .leading, spacing: 10) {
                    Button {
                        showImagePicker = true
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.9)) { showAttachmentMenu = false }
                    } label: {
                        Label("사진", systemImage: "photo.on.rectangle")
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .frame(maxWidth: 160, alignment: .leading)
                            .background(.clear)
                            .cornerRadius(10)
                    }
                    
                    Button {
                        showCamera = true
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.9)) { showAttachmentMenu = false }
                    } label: {
                        Label("카메라", systemImage: "camera")
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .frame(maxWidth: 160, alignment: .leading)
                            .background(.clear)
                            .cornerRadius(10)
                    }
                    
                }
                .font(.subheadline.bold())
                .foregroundColor(AppColors.brandOrange)
                .background(AppColors.brandBackground)
                .padding(.leading, 16)
                .padding(.bottom, 80)
                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                .cornerRadius(16)
                .transition(
                    .asymmetric(
                        insertion: .move(edge: .bottom).combined(with: .opacity),
                        removal: .move(edge: .bottom).combined(with: .opacity)
                    )
                )
            }
            .zIndex(10)
            }
        }
        .alert("실기기에서만 동작합니다", isPresented: $showCallAlert) {
            Button("확인", role: .cancel) { }
        }
        .ignoresSafeArea(edges: .bottom)
        
        .sheet(isPresented: $showImagePicker) {
            
            ImagePickerView(sourceType: .photoLibrary, selectedImage: $selectedImage)
                .onChange(of: selectedImage) { _, newValue in
                    if let img = newValue {
                        pendingImage = img
                        selectedImage = nil
                    }
                }
            
        }
        
        .fullScreenCover(isPresented: $showCamera) {
            ImagePickerView(sourceType: .camera, selectedImage: $selectedImage)
                .ignoresSafeArea()
                .onChange(of: selectedImage) { _, newValue in
                    if let img = newValue {
                        pendingImage = img
                        selectedImage = nil
                    }
                }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillChangeFrameNotification)) { notification in
            guard let userInfo = notification.userInfo,
                  let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
                  let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
                  let curveRaw = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else { return }
            let keyboardVisibleHeight = max(0, UIScreen.main.bounds.height - endFrame.origin.y)
            withAnimation(Animation.easeInOut(duration: duration)) {
                keyboardHeight = keyboardVisibleHeight
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { notification in
            guard let userInfo = notification.userInfo,
                  let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
            withAnimation(Animation.easeInOut(duration: duration)) {
                keyboardHeight = 0
            }
        }
    }
    
    // MARK: - 메서드
    private func sendMessage() {
        if let img = pendingImage {
            let trimmed = newMessage.trimmingCharacters(in: .whitespacesAndNewlines)
            let msg: ChatMessage
            if !trimmed.isEmpty {
                msg = ChatMessage(id: UUID().uuidString, text: trimmed, image: img, timestamp: Date(), isMyMessage: true, type: .image)
            } else {
                msg = ChatMessage(id: UUID().uuidString, image: img, timestamp: Date(), isMyMessage: true, type: .image)
            }
            messages.append(msg)
            pendingImage = nil
            newMessage = ""
            simulateAutoReply()
            return
        }
        
        guard !newMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        let msg = ChatMessage(id: UUID().uuidString, text: newMessage, timestamp: Date(), isMyMessage: true, type: .text)
        messages.append(msg)
        newMessage = ""
        simulateAutoReply()
    }
    
    private func simulateAutoReply() {
        isTyping = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            defer { isTyping = false }
            
            // 50% 확률로 이미지 응답, 아니면 텍스트 응답
            let sendImage = Bool.random()
            if sendImage {
                // 번들 이미지 시도
                let candidateNames = ["testImage1", "testImage2", "testImage3"]
                var pickedImage: UIImage? = nil
                for name in candidateNames {
                    if let ui = UIImage(named: name) { pickedImage = ui; break }
                }
                
                if let img = pickedImage ?? makePlaceholderImage(size: CGSize(width: 300, height: 200), color: .systemGray3) {
                    let captions = ["방금 찍은 사진이에요.", "이 옵션은 어떠세요?", "실물 컨디션 좋아요!", "참고 사진 드려요."]
                    let caption = Bool.random() ? (captions.randomElement() ?? "") : ""
                    
                    let reply: ChatMessage
                    if caption.isEmpty {
                        reply = ChatMessage(id: UUID().uuidString, image: img, timestamp: Date(), isMyMessage: false, type: .image)
                    } else {
                        reply = ChatMessage(id: UUID().uuidString, text: caption, image: img, timestamp: Date(), isMyMessage: false, type: .image)
                    }
                    messages.append(reply)
                    return
                }
            }
            
            let texts = [
                "네, 알겠습니다!",
                "확인해보고 다시 연락드릴게요.",
                "가능한 시간 알려주세요.",
                "사진 더 필요하시면 말씀 주세요.",
                "시운전도 가능합니다."
            ]
            let response = ChatMessage(id: UUID().uuidString, text: texts.randomElement() ?? "네, 알겠습니다!", timestamp: Date(), isMyMessage: false, type: .text)
            messages.append(response)
        }
    }
    
    private func makePlaceholderImage(size: CGSize, color: UIColor) -> UIImage? {
        let format = UIGraphicsImageRendererFormat()
        format.scale = UIScreen.main.scale
        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        return renderer.image { ctx in
            color.setFill()
            ctx.fill(CGRect(origin: .zero, size: size))
            UIColor.white.withAlphaComponent(0.3).setFill()
            let circleRect = CGRect(x: size.width*0.4, y: size.height*0.35, width: size.width*0.2, height: size.width*0.2)
            ctx.cgContext.fillEllipse(in: circleRect)
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
    ChatRoomView(
        seller: ChatSeller(id: "1", name: "미리보기 판매자", avatar: "placeholder", isOnline: true, lastSeen: Date(), phoneNumber: "010-0000-0000"),
        vehicle: ChatVehicle(id: "1", title: "프리뷰 차량", price: 1234, status: "판매중", image: "")
    )
}

