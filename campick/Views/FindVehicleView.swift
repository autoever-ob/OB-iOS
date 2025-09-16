//
//  FindVehicleView.swift
//  campick
//
//  Created by Admin on 9/16/25.
//

import SwiftUI

struct FindVehicleView: View {
    @State private var query: String = ""
    @State private var selectedBrands: Set<String> = ["전체"]

    let vehicleType = ["전체", "모터홈", "트레일러", "픽업캠퍼", "캠핑밴"]
    
    // Mock pools for placeholder generation
    private let prices = ["2,900만원","3,850만원","4,500만원","5,200만원"]
    private let years = ["2021년","2022년","2023년","2024년"]
    private let mileages = ["8,000km","12,000km","25,000km","40,000km"]
    private let fuelTypes = ["가솔린","디젤","하이브리드","전기"]
    private let transmissions = ["자동","수동"]
    private let locations = ["서울","부산","인천","대구"]
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.background.edgesIgnoringSafeArea(.all)
                VStack {
                    TopBarView(title: "매물 찾기") {
                        // 뒤로가기 액션 정의
                    }
                    
                    // 매물 검색 필드
                    ZStack(alignment: .leading) {
                        if query.isEmpty {
                            HStack(spacing: 8) {
                                Image(systemName: "magnifyingglass")
                                    .foregroundStyle(.white.opacity(0.7))
                                Text("차량명, 지역명으로 검색")
                                    .foregroundStyle(.white.opacity(0.6))
                            }
                            .padding(12)
                        }

                        HStack(spacing: 8) {
                            Image(systemName: "magnifyingglass")
                                .foregroundStyle(.white)
                            TextField("", text: $query)
                                .foregroundStyle(.white)
                                .tint(.white)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled(true)
                        }
                        .padding(12)
                    }
                    .background(Color.white.opacity(0.1))
                    .frame(maxWidth: 560)
                    .clipShape(Capsule())
                    .padding(.horizontal, 12)
                    .padding(.bottom, 10)
                    
                    // 자동차 브랜드 선택
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(vehicleType, id: \.self) { brand in
                                Chip(title: brand,
                                     isSelected: selectedBrands.contains(brand)) {
                                    if brand == "전체" {
                                        selectedBrands = ["전체"]
                                    } else {
                                        if
                                            selectedBrands.contains(brand) {
                                            selectedBrands.remove(brand)
                                        } else {
                                            selectedBrands.insert(brand)
                                        }
                                        selectedBrands.remove("전체")
                                        // If nothing is selected, fall back to "전체"
                                        if selectedBrands.isEmpty {
                                            selectedBrands = ["전체"]
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                    }

                    // 필터링
                    HStack(spacing: 12) {
                        Chip(title: "필터", isSelected: false, action: { /* TODO: open filter sheet */ },
                             systemImage: "slider.horizontal.3"
                        )
                        Spacer()
                        
                        Chip(title: "최근 등록순", isSelected: false, action: {
                            // 정렬 변경 처리
                        }, systemImage: "clock")
                    }
                    .padding(.horizontal, 12)
                    .padding(.top, 8)
                    
                    Rectangle()
                        .fill(Color.white.opacity(0.12))
                        .frame(height: 1)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 4)

                    // Mock content list without a model
                    ScrollView {
                        let columns = [GridItem(.adaptive(minimum: 300), spacing: 12, alignment: .top)]
                        LazyVGrid(columns: columns, spacing: 12) {
                            ForEach(0..<16, id: \.self) { index in
                                NavigationLink {
                                    // VehicleDetailView() --> 넣으면 됨 ㅋ
                                } label: {
                                    VehicleCardView(
                                        title: "차량 카드 목업 #\(index + 1)",
                                        price: prices.randomElement() ?? "2,900만원",
                                        year: years.randomElement() ?? "2023년",
                                        mileage: mileages.randomElement() ?? "12,000km",
                                        fuelType: fuelTypes.randomElement() ?? "가솔린",
                                        transmission: transmissions.randomElement() ?? "자동",
                                        location: locations.randomElement() ?? "서울",
                                        imageName: nil,
                                        thumbnailURL: URL(string: "https://picsum.photos/seed/\(index)/600/400"),
                                        isFavorite: Bool.random()
                                    )
                                }
                            }
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 12)
                    }
                }
            }
        }
    }
}

struct Chip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    var systemImage: String? = nil

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let systemImage {
                    Image(systemName: systemImage)
                }
                Text(title)
            }
            .font(.headline)
            .foregroundStyle(isSelected ? Color.white : Color.white.opacity(0.8))
            .padding(.vertical, 10)
            .padding(.horizontal, 18)
            .background(
                Capsule().fill(isSelected ? AppColors.brandOrange : Color.white.opacity(0.12))
            )
        }
        .buttonStyle(.plain)
        .contentShape(Capsule())
    }
}

#Preview {
    FindVehicleView()
}

