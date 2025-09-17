//
//  HomeView.swift
//  campick
//
//  Created by 오윤 on 9/15/25.
//

import SwiftUI

struct HomeView: View {
    @State private var showSlideMenu = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.brandBackground
                    .ignoresSafeArea()
                VStack(spacing: 0) {
                    HStack {
                        Text("Campick")
                            .font(.custom("Pacifico", size: 30))
                            .foregroundColor(.white)
                            .shadow(radius: 2)
                        
                        Spacer()
                        
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                    showSlideMenu = true
                                }
                        }) {
                            Image(systemName: "person")
                                .foregroundColor(.white)
                                .frame(width: 40, height: 40)
                                .background(AppColors.brandOrange)
                                .clipShape(Circle())
                        }
                    }
                    .padding()
                    .background(AppColors.brandBackground)
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            ZStack(alignment: .bottomLeading) {
                                Image("bannerImage")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 200)
                                    .clipped()
                                    .cornerRadius(20)
                                    .shadow(radius: 5)
                                
                                LinearGradient(
                                    gradient: Gradient(colors: [.black.opacity(0.8), .clear]),
                                    startPoint: .bottom,
                                    endPoint: .top
                                )
                                .cornerRadius(20)
                                
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("완벽한 캠핑카를\n찾아보세요")
                                        .font(.title)
                                        .bold()
                                        .foregroundColor(.white)
                                        .padding(.bottom, 7)
                                    Text("전국 최다 프리미엄 캠핑카 매물")
                                        .font(.system(size:13))
                                        .foregroundColor(.white.opacity(0.9))
                                }
                                .padding()
                            }
                            
                            NavigationLink(destination: FindVehicleView()) {
                                HStack {
                                    HStack {
                                        ZStack {
                                            Circle()
                                                .fill(AppColors.brandOrange.opacity(0.2))
                                                .frame(width: 48, height: 48)
                                            Image(systemName: "magnifyingglass")
                                                .foregroundColor(AppColors.brandOrange)
                                        }
                                        VStack(alignment: .leading) {
                                            Text("매물 찾기")
                                                .foregroundColor(.white)
                                                .bold()
                                            Text("원하는 캠핑카를 찾아보세요")
                                                .padding(.top,1)
                                                .font(.system(size: 10))
                                                .foregroundColor(.white.opacity(0.7))
                                            
                                        }
                                    }
                                    Spacer()
                                    Text("NEW")
                                        .font(.system(size:8))
                                        .bold()
                                        .padding(.vertical, 6)
                                        .padding(.horizontal,8)
                                        .background(AppColors.brandOrange)
                                        .foregroundColor(.white)
                                        .clipShape(Capsule())
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                        .font(.system(size:12))
                                }
                                .padding()
                                .background(.ultraThinMaterial.opacity(0.2))
                                .cornerRadius(16)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                                )
                            }
                            
                            VStack(alignment: .leading, spacing: 16) {
                                HStack {
                                    Image(systemName: "car.2.fill")
                                        .foregroundColor(AppColors.brandOrange)
                                        .scaledToFill()
                                    Text("차량 종류")
                                        .foregroundColor(.white)
                                        .font(.headline)
                                        .fontWeight(.heavy)
                                }
                                
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 16) {
                                    CategoryItem(image: "motorhome", title: "모터홈")
                                    CategoryItem(image: "trailer", title: "트레일러")
                                    CategoryItem(image: "pickup", title: "픽업캠퍼")
                                    CategoryItem(image: "van", title: "캠핑밴")
                                }
                            }
                            
                            VStack(spacing: 16) {
                                HStack {
                                    HStack {
                                        Image(systemName: "star.fill")
                                            .foregroundColor(AppColors.brandOrange)
                                        Text("추천 매물")
                                            .foregroundColor(.white)
                                            .font(.headline)
                                            .fontWeight(.heavy)
                                    }
                                    Spacer()
                                    NavigationLink(destination: Text("전체 매물")) {
                                        HStack {
                                            Text("전체보기")
                                                .foregroundColor(AppColors.brandLightOrange)
                                                .font(.system(size: 13))
                                                .fontWeight(.bold)
                                            Image(systemName: "chevron.right")
                                                .foregroundColor(AppColors.brandLightOrange)
                                                .font(.system(size: 8))
                                                .bold()
                                        }
                                    }
                                }
                                
                                VStack(spacing: 16) {
                                    FeaturedCard(image: "testImage1", title: "현대 포레스트", year: "2022년", distance: "15,000km", price: "8,900만원", rating: 4.8, badge: "NEW", badgeColor: AppColors.brandLightGreen)
                                    FeaturedCard(image: "testImage2", title: "기아 봉고 캠퍼", year: "2021년", distance: "32,000km", price: "4,200만원", rating: 4.6, badge: "HOT", badgeColor: AppColors.brandOrange)
                                }
                            }
                            
                            ZStack {
                                Image("bottomBannerImage")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 140)
                                    .cornerRadius(16)
                                    .clipped()
                                
                                LinearGradient(
                                    gradient: Gradient(colors: [.black.opacity(0.7), .clear]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                                .cornerRadius(16)
                                
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        HStack {
                                            Image(systemName: "flame.fill")
                                                .foregroundColor(AppColors.brandOrange)
                                            Text("첫 거래 특별 혜택")
                                                .foregroundColor(.white)
                                                .font(.caption)
                                                .fontWeight(.heavy)
                                        }
                                        Text("수수료 50% 할인")
                                            .foregroundColor(.white)
                                            .font(.headline)
                                            .fontWeight(.heavy)
                                    }
                                    Spacer()
                                    Button(action: {}) {
                                        Text("자세히 보기")
                                            .bold()
                                            .font(.system(size: 11))
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 8)
                                            .background(AppColors.brandOrange)
                                            .foregroundColor(.white)
                                            .clipShape(Capsule())
                                    }
                                }
                                .padding()
                                
                            }
                        }
                        .padding()
//                        .padding(.bottom,100) 하단배너
                    }
                    .safeAreaInset(edge: .bottom) {
                        BottomTabBarView(currentSelection: .home)
                    }
                   
                            
                }
                
                
                if showSlideMenu {
                    Color.black.opacity(0.5)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                showSlideMenu = false
                            }
                        }
                }
                
                // 슬라이드 메뉴
                HStack {
                    Spacer()
                    SlideMenu(showSlideMenu: $showSlideMenu)
                        .frame(width: 280)
                        .offset(x: showSlideMenu ? 0 : 300) // 오른쪽에서 슬라이드
                }
            }
            .animation(.easeInOut(duration: 0.3), value: showSlideMenu)
        }
    }
}

struct CategoryItem: View {
    var image: String
    var title: String
    
    var body: some View {
        VStack {
            
            Image(.category)
                .resizable()
                .scaledToFill()
                .frame(width: 70,height: 70)
                .cornerRadius(20)
                .shadow(radius: 3)
                .clipped()
                .padding(.bottom, 5)
            Text(title)
                .font(.caption)
                .foregroundColor(.white)
                .bold()
        }
    }
}

struct FeaturedCard: View {
    var image: String
    var title: String
    var year: String
    var distance: String
    var price: String
    var rating: Double
    var badge: String
    var badgeColor: Color
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack(alignment: .topTrailing) {
                Image(image)
                    .resizable()
                    .frame(width: 90, height: 90)
                    .cornerRadius(12)
                    .shadow(radius: 3)
                
                Text(badge)
                    .font(.system(size:8))
                    .bold()
                    .padding(.vertical, 4)
                    .padding(.horizontal,6)
                    .background(badgeColor)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding(4)
                    .offset(x: 6, y: -10)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(title)
                        .foregroundColor(.white)
                        .bold()
                    Spacer()
                    Button(action: {}) {
                        Image(systemName: "heart")
                            .foregroundColor(.white.opacity(0.7))
                    }
                }
                
                HStack(spacing: 8) {
                    Text(year)
                        .font(.caption)
                        .padding(4)
                        .background(.ultraThinMaterial)
                        .cornerRadius(6)
                        .foregroundColor(.white.opacity(0.8))
                    Text(distance)
                        .font(.caption)
                        .padding(4)
                        .background(.ultraThinMaterial)
                        .cornerRadius(6)
                        .foregroundColor(.white.opacity(0.8))
                }
                
                HStack {
                    Text(price)
                        .foregroundColor(.white)
                        .font(.headline)
                    Spacer()
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.caption)
                        Text(String(format: "%.1f", rating))
                            .foregroundColor(.yellow)
                            .font(.caption)
                    }
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial.opacity(0.2))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
        )
    }
}



struct TabItem: View {
    var icon: String
    var label: String
    var active: Bool = false
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .foregroundColor(active ? .orange : .white.opacity(0.6))
            Text(label)
                .font(.caption2)
                .foregroundColor(active ? .orange : .white.opacity(0.6))
        }
    }
}

struct SlideMenu: View {
    @Binding var showSlideMenu: Bool
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                
                HStack {
                    Text("메뉴")
                        .foregroundColor(.white)
                        .font(.headline)
                        
                    Spacer()
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                                showSlideMenu = false
                            }
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                    }
                }
                .padding()
                .padding(.top, 50)
                
                VStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 12) {
                                Image("bannerImage",bundle: nil)
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("사용자님")
                                        .font(.system(size: 14, weight: .heavy))
                                        .foregroundColor(.white)
                                    Text("캠핑카 애호가")
                                        .font(.system(size: 11))
                                        .foregroundColor(.white.opacity(0.6))
                                }
                                .padding(.leading, 2)
                            }
                            .padding(.bottom,1)
                            
                            Button(action: { /* 프로필 화면 이동 */ }) {
                                Text("프로필 보기")
                                    .font(.system(size: 12, weight:.heavy))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 8)
                                    .background(AppColors.brandOrange)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                        }
                        .padding()
                        .background(.ultraThinMaterial.opacity(0.2))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                        )
                        .padding(.horizontal)
                    VStack(spacing: 20){
                        MenuItem(icon: "car.fill", title: "내 매물", subtitle: "등록한 매물 관리")
                        MenuItem(icon: "message", title: "채팅", subtitle: "진행중인 대화", badge: "3")
                    }
                    .padding(10)
//                    .padding(.top, 20)
//                    .padding(.horizontal, 10)
                    
                }
                .padding(.top)
                
                Spacer()
 
                Button(action: {}) {
                    HStack {
                        Image(systemName: "arrow.backward.square")
                            .font(.system(size: 13))
                        Text("로그아웃")
                            .font(.system(size: 13))
                    }
                    .foregroundColor(.red)
                    .padding()
                }
                .padding(.bottom, 20)
                
            }
            .frame(width: 280)
            .background(Color(red: 0.043, green: 0.129, blue: 0.102))
            .ignoresSafeArea()
        }
    }
}



struct MenuItem: View {
    var icon: String
    var title: String
    var subtitle: String
    var badge: String? = nil
    
    var body: some View {
        NavigationLink(destination: ChatRoomListView(rooms: [
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
            
        ])){
            HStack {
                ZStack(alignment: .topTrailing) {
                    Circle()
                        .fill(.ultraThinMaterial.opacity(0.2))
                        .frame(width: 35, height: 35)
                        .overlay(
                            Image(systemName: icon)
                                .font(.system(size: 13))
                                .foregroundColor(AppColors.brandOrange)
                        )
                    
                    if let badge = badge {
                        Text(badge)
                            .font(.system(size: 9))
                            .bold()
                            .frame(width: 16, height: 16)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .offset(x: 2, y: -3)
                    }
                }
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.system(size: 14, weight: .heavy))
                        .foregroundColor(.white)
                    Spacer()
                        .frame(height: 2)
                    Text(subtitle)
                        .font(.system(size: 11, weight: .light))
                        .foregroundColor(.white.opacity(0.6))
                        
                }
                Spacer()
            }
            .padding(.horizontal)
        }
        
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
