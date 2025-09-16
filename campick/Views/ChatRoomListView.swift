//
//  ChatRoomListView.swift
//  campick
//
//  Created by oyun on 2025-09-16.
//

import SwiftUI

struct ChatRoom: Identifiable,Hashable {
    let id: String
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
}

struct ChatRoomListView: View {
    let rooms: [ChatRoom]
    
    
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
                if rooms.isEmpty {
                    VStack {
                        Circle()
                            .fill(Color.white.opacity(0.1))
                            .frame(width: 80, height: 80)
                            .overlay(
                                Image(systemName: "message")
                                    .foregroundColor(.white.opacity(0.4))
                                    .font(.system(size: 28))
                            )
                            .padding(.bottom, 8)
                        
                        Text("진행중인 채팅이 없습니다")
                            .foregroundColor(.white)
                            .font(.headline)
                        Text("매물에 관심이 있으시면 판매자에게 메시지를 보내보세요!")
                            .foregroundColor(.white.opacity(0.6))
                            .font(.caption)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                            .padding(.bottom, 16)
                        
                        Button(action: { }) {
                            Text("매물 찾아보기")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.orange)
                                .foregroundColor(.white)
                                .cornerRadius(30)
                        }
                        .padding(.horizontal, 40)
                    }
                    .frame(maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(rooms) { room in
                                NavigationLink(value: room) {
                                    ChatRoomRow(room: room)
                                }
                            }
                        }
                        
                    }
                    .padding(.horizontal)
                }
            }
            .background(AppColors.brandBackground)
            .navigationTitle("채팅")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: ChatRoom.self) { room in
                ChatView(sellerName: room.sellerName, sellerAvatar: room.sellerAvatar)
            }
            .safeAreaInset(edge: .bottom) {
                BottomTabBarView(currentSelection: .home)
            }
        }
    }
}

struct ChatRoomRow: View {
    let room: ChatRoom
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack(alignment: .bottomTrailing) {
                Image(room.sellerAvatar)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 48, height: 48)
                    .clipShape(Circle())
                
                if room.isOnline {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 12, height: 12)
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                        .offset(x: -2, y: 1)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(room.sellerName)
                        .foregroundColor(.white)
                        .font(.system(size: 15, weight: .heavy))
                    
                    Spacer()
                    HStack{
                        Text(formatTime(room.lastMessageTime))
                            .foregroundColor(.white.opacity(0.6))
                            .font(.caption)
                        if room.unreadCount > 0 {
                            Text("\(room.unreadCount)")
                                .font(.system(size: 10))
                                .bold()
                                .padding(.bottom, 3)
                                .padding(.top,2)
                                .padding(.horizontal,6)
                                .background(Color.red)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                            
                        }
                    }
                    
                }
                
                HStack {
                    Image(room.vehicleImage)
                        .resizable()
                        .frame(width: 30, height: 20)
                        .cornerRadius(4)
                    Text(room.vehicleTitle)
                        .foregroundColor(.white.opacity(0.8))
                        .font(.caption)
                        .lineLimit(1)
                }
                
                Text(room.lastMessage)
                    .foregroundColor(.white.opacity(0.6))
                    .font(.subheadline)
                    .lineLimit(1)
            }
            
            
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.ultraThinMaterial.opacity(0.2))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
        )
        
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "a h:mm"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
}



#Preview {
    ChatRoomListView(rooms: [
        ChatRoom(
            id: "1",
            sellerId: "seller1",
            sellerName: "김캠핑",
            sellerAvatar: "tiffany",
            vehicleId: "1",
            vehicleTitle: "현대 포레스트 프리미엄",
            vehicleImage: "testImage1",
            lastMessage: "안녕하세요!",
            lastMessageTime: Date(),
            unreadCount: 2,
            isOnline: true
        ),
        ChatRoom(
            id: "2",
            sellerId: "seller2",
            sellerName: "박모터홈",
            sellerAvatar: "mrchu",
            vehicleId: "2",
            vehicleTitle: "기아 봉고 캠퍼",
            vehicleImage: "testImage2",
            lastMessage: "내일 뵙겠습니다.",
            lastMessageTime: Date().addingTimeInterval(-3600),
            unreadCount: 0,
            isOnline: false
        )
        ,
        ChatRoom(
            id: "3",
            sellerId: "seller3",
            sellerName: "판매자 3",
            sellerAvatar: "https://randomuser.me/api/portraits/men/3.jpg",
            vehicleId: "3",
            vehicleTitle: "캠핑카 모델 3",
            vehicleImage: "https://picsum.photos/200/120?random=3",
            lastMessage: "좋은 하루 되세요!",
            lastMessageTime: Date().addingTimeInterval(-1800),
            unreadCount: 1,
            isOnline: true
        ),
        ChatRoom(
            id: "4",
            sellerId: "seller4",
            sellerName: "판매자 4",
            sellerAvatar: "https://randomuser.me/api/portraits/women/4.jpg",
            vehicleId: "4",
            vehicleTitle: "캠핑카 모델 4",
            vehicleImage: "https://picsum.photos/200/120?random=4",
            lastMessage: "안녕하세요!",
            lastMessageTime: Date().addingTimeInterval(-2400),
            unreadCount: 3,
            isOnline: false
        ),
        ChatRoom(
            id: "5",
            sellerId: "seller5",
            sellerName: "판매자 5",
            sellerAvatar: "https://randomuser.me/api/portraits/men/5.jpg",
            vehicleId: "5",
            vehicleTitle: "캠핑카 모델 5",
            vehicleImage: "https://picsum.photos/200/120?random=5",
            lastMessage: "내일 뵙겠습니다.",
            lastMessageTime: Date().addingTimeInterval(-3000),
            unreadCount: 0,
            isOnline: true
        ),
        ChatRoom(
            id: "6",
            sellerId: "seller6",
            sellerName: "판매자 6",
            sellerAvatar: "https://randomuser.me/api/portraits/women/6.jpg",
            vehicleId: "6",
            vehicleTitle: "캠핑카 모델 6",
            vehicleImage: "https://picsum.photos/200/120?random=6",
            lastMessage: "좋은 하루 되세요!",
            lastMessageTime: Date().addingTimeInterval(-3600),
            unreadCount: 2,
            isOnline: false
        ),
        ChatRoom(
            id: "7",
            sellerId: "seller7",
            sellerName: "판매자 7",
            sellerAvatar: "https://randomuser.me/api/portraits/men/7.jpg",
            vehicleId: "7",
            vehicleTitle: "캠핑카 모델 7",
            vehicleImage: "https://picsum.photos/200/120?random=7",
            lastMessage: "안녕하세요!",
            lastMessageTime: Date().addingTimeInterval(-4200),
            unreadCount: 1,
            isOnline: true
        ),
        ChatRoom(
            id: "8",
            sellerId: "seller8",
            sellerName: "판매자 8",
            sellerAvatar: "https://randomuser.me/api/portraits/women/8.jpg",
            vehicleId: "8",
            vehicleTitle: "캠핑카 모델 8",
            vehicleImage: "https://picsum.photos/200/120?random=8",
            lastMessage: "내일 뵙겠습니다.",
            lastMessageTime: Date().addingTimeInterval(-4800),
            unreadCount: 3,
            isOnline: false
        ),
        ChatRoom(
            id: "9",
            sellerId: "seller9",
            sellerName: "판매자 9",
            sellerAvatar: "https://randomuser.me/api/portraits/men/9.jpg",
            vehicleId: "9",
            vehicleTitle: "캠핑카 모델 9",
            vehicleImage: "https://picsum.photos/200/120?random=9",
            lastMessage: "좋은 하루 되세요!",
            lastMessageTime: Date().addingTimeInterval(-5400),
            unreadCount: 0,
            isOnline: true
        ),
        ChatRoom(
            id: "10",
            sellerId: "seller10",
            sellerName: "판매자 10",
            sellerAvatar: "https://randomuser.me/api/portraits/women/10.jpg",
            vehicleId: "10",
            vehicleTitle: "캠핑카 모델 10",
            vehicleImage: "https://picsum.photos/200/120?random=10",
            lastMessage: "안녕하세요!",
            lastMessageTime: Date().addingTimeInterval(-6000),
            unreadCount: 2,
            isOnline: false
        ),
        
    ])
}
