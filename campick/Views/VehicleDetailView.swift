//
//  VehicleDetailView.swift
//  campick
//
//  Created by 김호집 on 9/16/25.
//

import SwiftUI

struct VehicleDetailView: View {
    @Environment(\.dismiss) private var dismiss
    let vehicleId: String
    @State private var currentImageIndex = 0
    @State private var showSellerModal = false
    @State private var isFavorite = false
    @State private var chatMessage = ""

    // Mock data
    private var vehicleData: VehicleData {
        VehicleData(
            id: vehicleId,
            title: "현대 포레스트 프리미엄",
            images: Array(1...8).map { _ in "bannerImage" }, // 8개 이미지로 확장 기능 테스트
            price: 8900,
            year: 2022,
            mileage: 15000,
            type: "모터홈",
            description: "완벽한 상태의 프리미엄 모터홈입니다. 정기적인 관리로 최상의 컨디션을 유지하고 있으며, 모든 편의시설이 완비되어 있습니다. 전국 어디든 캐핑을 즐길 수 있는 최고의 선택입니다.",
            seller: Seller(
                id: "seller_001",
                name: "김캠핑",
                avatar: "bannerImage",
                totalListings: 12,
                totalSales: 8,
                rating: 4.8,
                isDealer: true
            ),
            location: "서울 강남구",
            features: ["에어컨", "히터", "냉장고", "전자레인지", "화장실", "샤워시설", "소파베드", "테이블", "가스레인지", "오디오 시스템", "TV", "넓은 수납공간", "외부 차양", "태양광 패널", "인버터", "외부 샤워기"]
        )
    }

    var body: some View {
        ZStack {
            AppColors.background
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {
                    VehicleImageGallery(
                        currentImageIndex: $currentImageIndex,
                        images: vehicleData.images,
                        onBackTap: {
                            dismiss()
                        },
                        onShareTap: {
                            // TODO: Share functionality
                            print("공유하기")
                        }
                    )

                    VehicleInfoCard(
                        title: vehicleData.title,
                        price: vehicleData.price,
                        year: vehicleData.year,
                        mileage: vehicleData.mileage,
                        type: vehicleData.type,
                        location: vehicleData.location
                    )

                    VehicleSellerCard(
                        seller: vehicleData.seller,
                        onTap: { showSellerModal = true }
                    )

                    VehicleFeaturesCard(features: vehicleData.features)

                    VehicleDescriptionCard(description: vehicleData.description)

                    Spacer(minLength: 120)
                }
            }

            VStack {
                Spacer()
                HStack(spacing: 12) {
                    Button(action: { isFavorite.toggle() }) {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .foregroundColor(isFavorite ? .red : .white)
                            .frame(width: 48, height: 48)
                            .background(Color.white.opacity(0.1))
                            .overlay(
                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            )
                            .clipShape(Circle())
                    }

                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color.white.opacity(0.1))
                            .overlay(
                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            )
                            .frame(height: 48)

                        HStack {
                            if chatMessage.isEmpty {
                                Text("안녕하세요. 문의하고싶습니다.")
                                    .foregroundColor(.white.opacity(0.5))
                                    .allowsHitTesting(false)
                            }
                            Spacer()
                        }
                        .padding(.horizontal, 16)

                        TextField("", text: $chatMessage)
                            .textFieldStyle(PlainTextFieldStyle())
                            .foregroundColor(.white)
                            .accentColor(.orange)
                            .padding(.horizontal, 16)
                    }

                    Button(action: {
                        // TODO: Navigate to chat page
                        print("채팅 페이지로 이동: \(chatMessage)")
                        chatMessage = ""
                    }) {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(.white)
                            .frame(width: 48, height: 48)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [AppColors.brandOrange, AppColors.brandLightOrange]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 2)
                    }
                    .disabled(chatMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    .opacity(chatMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.6 : 1.0)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 17)
                .background(AppColors.background.opacity(0.95))
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.white.opacity(0.1)),
                    alignment: .top
                )
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showSellerModal) {
            SellerModalView(seller: vehicleData.seller)
        }
    }
}

struct VehicleData {
    let id: String
    let title: String
    let images: [String]
    let price: Int
    let year: Int
    let mileage: Int
    let type: String
    let description: String
    let seller: Seller
    let location: String
    let features: [String]
}

#Preview {
    NavigationView {
        VehicleDetailView(vehicleId: "1")
    }
}
