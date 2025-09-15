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
                Color.brandBackground
                    .ignoresSafeArea()
                VStack(spacing: 0) {
                    HStack {
                        Text("CampVan")
                            .font(.custom("Pacifico", size: 24))
                            .foregroundColor(.white)
                            .shadow(radius: 2)
                        
                        Spacer()
                        
                        Button(action: { showSlideMenu.toggle() }) {
                            Image(systemName: "person")
                                .foregroundColor(.white)
                                .frame(width: 40, height: 40)
                                .background(Color.brandOrange)
                                .clipShape(Circle())
                        }
                    }
                    .padding()
                    .background(Color.brandBackground)
                    
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
                                    Text("전국 최다 프리미엄 캠핑카 매물")
                                        .foregroundColor(.white.opacity(0.9))
                                }
                                .padding()
                            }
                            
                            NavigationLink(destination: Text("매물찾기 화면")) {
                                HStack {
                                    HStack {
                                        ZStack {
                                            Circle()
                                                .fill(Color.brandOrange.opacity(0.2))
                                                .frame(width: 48, height: 48)
                                            Image(systemName: "magnifyingglass")
                                                .foregroundColor(.brandOrange)
                                        }
                                        VStack(alignment: .leading) {
                                            Text("매물 찾기")
                                                .foregroundColor(.white)
                                                .bold()
                                            Text("원하는 캠핑카를 찾아보세요")
                                                .font(.caption)
                                                .foregroundColor(.white.opacity(0.7))
                                        }
                                    }
                                    Spacer()
                                    Text("NEW")
                                        .font(.caption)
                                        .bold()
                                        .padding(6)
                                        .background(Color.brandOrange)
                                        .foregroundColor(.white)
                                        .clipShape(Capsule())
                                }
                                .padding()
                                .background(.ultraThinMaterial)
                                .cornerRadius(16)
                            }
                            
                            VStack(alignment: .leading, spacing: 16) {
                                HStack {
                                    Image(systemName: "car.2.fill")
                                        .foregroundColor(.brandOrange)
                                        .scaledToFill()
                                    Text("차량 종류")
                                        .foregroundColor(.white)
                                        .font(.headline)
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
                                            .foregroundColor(.brandOrange)
                                        Text("추천 매물")
                                            .foregroundColor(.white)
                                            .font(.headline)
                                    }
                                    Spacer()
                                    NavigationLink(destination: Text("전체 매물")) {
                                        HStack {
                                            Text("전체보기")
                                                .foregroundColor(.brandLightOrange)
                                                .font(.subheadline)
                                            Image(systemName: "chevron.right")
                                                .foregroundColor(.brandLightOrange)
                                        }
                                    }
                                }
                                
                                VStack(spacing: 16) {
                                    FeaturedCard(image: "testImage1", title: "현대 포레스트", year: "2022년", distance: "15,000km", price: "8,900만원", rating: 4.8, badge: "NEW", badgeColor: .brandLightGreen)
                                    FeaturedCard(image: "testImage2", title: "기아 봉고 캠퍼", year: "2021년", distance: "32,000km", price: "4,200만원", rating: 4.6, badge: "HOT", badgeColor: .brandOrange)
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
                                                .foregroundColor(.brandOrange)
                                            Text("첫 거래 특별 혜택")
                                                .foregroundColor(.white)
                                                .font(.caption)
                                        }
                                        Text("수수료 50% 할인")
                                            .foregroundColor(.white)
                                            .font(.headline)
                                    }
                                    Spacer()
                                    Button(action: {}) {
                                        Text("자세히 보기")
                                            .bold()
                                            .font(.caption)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 8)
                                            .background(Color.brandOrange)
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
                    .toolbar {
                        BottomTabBar(currentSelection: .home)
                    }
                    .toolbarBackground(Color.brandBackground, for: .bottomBar)
                    .toolbarBackground(.visible, for: .bottomBar)
                            
                }
                
                
                if showSlideMenu {
                    Color.black.opacity(0.5)
                        .ignoresSafeArea()
                        .onTapGesture { showSlideMenu = false }
                    
                    SlideMenu(showSlideMenu: $showSlideMenu)
                        .transition(.move(edge: .trailing))
                }
            }
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
                    .font(.caption2)
                    .bold()
                    .padding(4)
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
        .background(.ultraThinMaterial)
        .cornerRadius(16)
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
                    Button(action: { showSlideMenu = false }) {
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
                                    .frame(width: 48, height: 48)
                                    .clipShape(Circle())
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("사용자님")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    Text("캠핑카 애호가")
                                        .font(.subheadline)
                                        .foregroundColor(.white.opacity(0.6))
                                }
                            }
                            
                            Button(action: { /* 프로필 화면 이동 */ }) {
                                Text("프로필 보기")
                                    .font(.subheadline).bold()
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 8)
                                    .background(Color.brandOrange)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(12)
                        .padding(.horizontal)
                    MenuItem(icon: "car.fill", title: "내 매물", subtitle: "등록한 매물 관리")
                    MenuItem(icon: "message", title: "채팅", subtitle: "진행중인 대화", badge: "3")
                }
                .padding(.top)
                
                
                
                Button(action: {}) {
                    HStack {
                        Image(systemName: "arrow.backward.square")
                        Text("로그아웃")
                    }
                    .foregroundColor(.red)
                    .padding()
                }
                Spacer()
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
        HStack {
            ZStack(alignment: .topTrailing) {
                Circle()
                    .fill(.ultraThinMaterial)
                    .frame(width: 40, height: 40)
                    .overlay(
                        Image(systemName: icon)
                            .foregroundColor(.brandOrange)
                    )
                
                if let badge = badge {
                    Text(badge)
                        .font(.caption2)
                        .bold()
                        .frame(width: 16, height: 16)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                        .offset(x: 8, y: -8)
                }
            }
            VStack(alignment: .leading) {
                Text(title)
                    .foregroundColor(.white)
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.6))
            }
            Spacer()
        }
        .padding(.horizontal)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
