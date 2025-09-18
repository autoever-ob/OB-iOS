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
        ZStack {
            AppColors.brandBackground
                .ignoresSafeArea()
            VStack(spacing: 0) {
                // 헤더
                Header(showSlideMenu: $showSlideMenu)
                // 컨텐츠 섹션
                ScrollView {
                    VStack(spacing: 24) {
                        // 상단 배너
                        TopBanner()
                        // 매물 찾기
                        FindVehicle()
                        // 차량 종류
                        VehicleCategory()
                        // 추천 매물
                        RecommendVehicle()
                        // 하단 배너
                        BottomBanner()
                    }
                    .padding()
                }
                .safeAreaInset(edge: .bottom) {
                    BottomTabBarView(currentSelection: .home)
                }
            }
            // 슬라이드 메뉴
            ProfileMenu(showSlideMenu: $showSlideMenu)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

