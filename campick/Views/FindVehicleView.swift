//
//  FindVehicleView.swift
//  campick
//
//  Created by 김호집 on 9/16/25.
//

import SwiftUI

struct FindVehicleView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var query: String = ""

    // Filter and Sort State
    @State private var showingFilter = false
    @State private var showingSortView = false
    @State private var filterOptions = FilterOptions()
    @State private var selectedSort: SortOption = .recentlyAdded

    @State private var vehicles: [Vehicle] = [
        Vehicle(id: "1", imageName: "testImage3", thumbnailURL: nil, title: "모터홈 A", price: "2,900만원", year: "2021년", mileage: "8,000km", fuelType: "가솔린", transmission: "자동", location: "서울", status: .active, postedDate: "1일 전", isOnSale: true, isFavorite: false),
        Vehicle(id: "2", imageName: "testImage3", thumbnailURL: nil, title: "트레일러 B", price: "3,850만원", year: "2022년", mileage: "12,000km", fuelType: "디젤", transmission: "수동", location: "부산", status: .active, postedDate: "2일 전", isOnSale: true, isFavorite: false),
        Vehicle(id: "3", imageName: "testImage3", thumbnailURL: nil, title: "픽업캠퍼 C", price: "4,500만원", year: "2023년", mileage: "25,000km", fuelType: "하이브리드", transmission: "자동", location: "인천", status: .active, postedDate: "3일 전", isOnSale: true, isFavorite: false),
        Vehicle(id: "4", imageName: "testImage3", thumbnailURL: nil, title: "캠핑밴 D", price: "5,200만원", year: "2024년", mileage: "40,000km", fuelType: "전기", transmission: "수동", location: "대구", status: .active, postedDate: "4일 전", isOnSale: true, isFavorite: false),
        Vehicle(id: "5", imageName: "testImage3", thumbnailURL: nil, title: "모터홈 E", price: "3,200만원", year: "2020년", mileage: "15,000km", fuelType: "디젤", transmission: "자동", location: "광주", status: .active, postedDate: "5일 전", isOnSale: true, isFavorite: false),
        Vehicle(id: "6", imageName: "testImage3", thumbnailURL: nil, title: "트레일러 F", price: "2,800만원", year: "2021년", mileage: "5,000km", fuelType: "가솔린", transmission: "자동", location: "대전", status: .active, postedDate: "오늘", isOnSale: true, isFavorite: false),
        Vehicle(id: "7", imageName: "testImage3", thumbnailURL: nil, title: "픽업캠퍼 G", price: "6,000만원", year: "2023년", mileage: "30,000km", fuelType: "디젤", transmission: "수동", location: "제주", status: .active, postedDate: "6일 전", isOnSale: true, isFavorite: false),
        Vehicle(id: "8", imageName: "testImage3", thumbnailURL: nil, title: "캠핑밴 H", price: "4,000만원", year: "2022년", mileage: "20,000km", fuelType: "하이브리드", transmission: "자동", location: "울산", status: .active, postedDate: "7일 전", isOnSale: true, isFavorite: false)
    ]

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
                            .onSubmit {
                                // In production: Call API with search query
                                fetchVehicles()
                            }
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
                        showingFilter = true
                    }

                    Spacer()

                        /* 정렬 변경 처리 */
                    Chip(title: selectedSort.rawValue, systemImage: "arrow.up.arrow.down", isSelected: false) {
                        showingSortView = true
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
                        ForEach(vehicles, id: \.id) { vehicle in
                            NavigationLink {
                                VehicleDetailView(vehicleId: vehicle.id)
                            } label: {
                                VehicleCardView(
                                    title: vehicle.title,
                                    price: vehicle.price,
                                    year: vehicle.year,
                                    mileage: vehicle.mileage,
                                    fuelType: vehicle.fuelType,
                                    transmission: vehicle.transmission,
                                    location: vehicle.location,
                                    imageName: vehicle.imageName,
                                    thumbnailURL: vehicle.thumbnailURL,
                                    isOnSale: vehicle.isOnSale,
                                    isFavorite: vehicle.isFavorite
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
        .overlay {
            ZStack {
                if showingFilter {
                    FilterView(
                        filters: $filterOptions,
                        isPresented: $showingFilter
                    )
                    .zIndex(1)
                }

                if showingSortView {
                    SortView(
                        selectedSort: $selectedSort,
                        isPresented: $showingSortView
                    )
                    .zIndex(1)
                }
            }
        }
        .onChange(of: filterOptions) { _, _ in
            fetchVehicles()
        }
        .onChange(of: selectedSort) { _, _ in
            fetchVehicles()
        }
        .onAppear {
            fetchVehicles()
        }
    }

    private func fetchVehicles() {
    }
}

#Preview {
    FindVehicleView()
}
