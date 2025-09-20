//
//  ProfileMenu.swift
//  campick
//
//  Created by Admin on 9/18/25.
//

import SwiftUI


struct ProfileMenu: View {
    @Binding var showSlideMenu: Bool
    @State private var navigateToProfile = false
    @StateObject private var userState = UserState.shared
    
    var body: some View {
        ZStack{
            if showSlideMenu {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showSlideMenu = false
                        }
                    }
            }
            
            HStack {
                Spacer()
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
                                        Text(userState.name.isEmpty ? "사용자님" : userState.name)
                                            .font(.system(size: 14, weight: .heavy))
                                            .foregroundColor(.white)
//                                        Text(userState.nickName.isEmpty ? "캠핑카 애호가" : userState.nickName)
//                                            .font(.system(size: 11))
//                                            .foregroundColor(.white.opacity(0.6))
                                    }
                                    .padding(.leading, 2)
                                }
                                .padding(.bottom,1)
                                
                                Button(action: {
                                    showSlideMenu = false
                                    navigateToProfile = true
                                }) {
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
                                MenuItem(icon: "car.fill", title: "내 매물", subtitle: "등록한 매물 관리", destination: AnyView(Text("내 매물")), showSlideMenu: $showSlideMenu )
                                MenuItem(icon: "message", title: "채팅", subtitle: "진행중인 대화", badge: "3", destination: AnyView(ChatRoomListView()),  showSlideMenu: $showSlideMenu)
                            }
                            .padding(10)
                            
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
                .navigationDestination(isPresented: $navigateToProfile) {
                    ProfileView(memberId: userState.memberId, isOwnProfile: true)
                }
                .frame(width: 280)
                .offset(x: showSlideMenu ? 0 : 300) // 오른쪽에서 슬라이드
                .environmentObject(UserState.shared)
            }
        }
        .zIndex(300)
        
    }
}

