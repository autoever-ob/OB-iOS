//
//  FindVehicleView.swift
//  campick
//
//  Created by Admin on 9/16/25.
//

import SwiftUI

struct FindVehicleView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var query: String = ""
    @State private var selectedBrands: Set<String> = ["전체"]

    // 목업데이터
    let vehicleType = ["전체", "모터홈", "트레일러", "픽업캠퍼", "캠핑밴"]
    private let prices = ["2,900만원","3,850만원","4,500만원","5,200만원"]
    private let years = ["2021년","2022년","2023년","2024년"]
    private let mileages = ["8,000km","12,000km","25,000km","40,000km"]
    private let fuelTypes = ["가솔린", "디젤", "하이브리드", "전기"]
    private let transmissions = ["자동","수동", "자동", "수동"]
    private let locations = ["서울","부산","인천","대구"]
    
    var body: some View {
        ZStack {
            AppColors.background.edgesIgnoringSafeArea(.all)
            VStack {
                TopBarView(title: "매물 찾기") {
                    dismiss()
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
                .padding(.bottom, 4)
                
                // 자동차 브랜드 선택(선택)
//                ScrollView(.horizontal, showsIndicators: false) {
//                    HStack(spacing: 12) {
//                        ForEach(vehicleType, id: \.self) { brand in
//                            Chip(title: brand,
//                                 isSelected: selectedBrands.contains(brand)) {
//                                if brand == "전체" {
//                                    selectedBrands = ["전체"]
//                                } else {
//                                    if
//                                        selectedBrands.contains(brand) {
//                                        selectedBrands.remove(brand)
//                                    } else {
//                                        selectedBrands.insert(brand)
//                                    }
//                                    selectedBrands.remove("전체")
//                                    if selectedBrands.isEmpty {
//                                        selectedBrands = ["전체"]
//                                    }
//                                }
//                            }
//                        }
//                    }
//                    .padding(.horizontal, 12)
//                }

                // 필터링
                HStack(spacing: 12) {
                    Chip(title: "필터", systemImage: "line.3.horizontal.decrease.circle", isSelected: false) {
                        /* 필터 철 */
                    }

                    Spacer()

                    Chip(title: "최근 등록순", systemImage: "arrow.up.arrow.down", isSelected: false) {
                        /* 정렬 변경 처리 */
                    }
                }
                .padding(.horizontal, 12)
                .padding(.top, 4)
                
                Rectangle()
                    .fill(Color.white.opacity(0.12))
                    .frame(height: 1)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 4)

                // 매물 카드뷰 리스트
                ScrollView {
                    let columns = [GridItem(.adaptive(minimum: 300), spacing: 12, alignment: .top)]
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(0..<4, id: \.self) { index in
                            NavigationLink {
                                Text("상세 페이지")
                            } label: {
                                VehicleCardView(
                                    title: "차량 카드 목업 #\(index + 1)",
                                    price: prices[index] ,
                                    year: years[index],
                                    mileage: mileages[index],
                                    fuelType: fuelTypes[index],
                                    transmission: transmissions[index],
                                    location: locations[index],
                                    imageName: "testImage3",
                                    thumbnailURL: nil,
                                    isOnSale: true,
                                    isFavorite: true
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 12)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    FindVehicleView()
}
