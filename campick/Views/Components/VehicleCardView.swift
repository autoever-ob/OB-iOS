//
//  VehicleCardView.swift
//  campick
//
//  Admin이 2025-09-16에 작성함
//

import SwiftUI

struct VehicleCardView: View {
    // MARK: - 렌더링에 사용되는 저장 프로퍼티
    private let imageName: String?
    private let thumbnailURL: URL?
    private let title: String
    private let price: String
    private let year: String
    private let mileage: String
    private let fuelType: String
    private let transmission: String
    private let location: String
    private let isOnSale: Bool
    @State private var isFavorite: Bool

    // MARK: - 디자인 상수
    private let cornerRadius: CGFloat = 12
    private let imageHeight: CGFloat = 180

    // MARK: - 이니셜라이저
    // 1) 모델 기반 이니셜라이저(하위 호환)
    init(vehicle: Vehicle) {
        self.imageName = vehicle.imageName
        self.thumbnailURL = vehicle.thumbnailURL
        self.title = vehicle.title
        self.price = vehicle.price
        self.year = vehicle.year
        self.mileage = vehicle.mileage
        self.fuelType = vehicle.fuelType
        self.transmission = vehicle.transmission
        self.location = vehicle.location
        self.isOnSale = vehicle.isOnSale
        self._isFavorite = State(initialValue: vehicle.isFavorite)
    }

    // 2) 목업 데이터용 이니셜라이저
    init(
        title: String,
        price: String,
        year: String = "-",
        mileage: String = "-",
        fuelType: String = "-",
        transmission: String = "-",
        location: String,
        imageName: String? = nil,
        thumbnailURL: URL? = nil,
        isOnSale: Bool = true,
        isFavorite: Bool = false
    ) {
        self.imageName = imageName
        self.thumbnailURL = thumbnailURL
        self.title = title
        self.price = price
        self.year = year
        self.mileage = mileage
        self.fuelType = fuelType
        self.transmission = transmission
        self.location = location
        self.isOnSale = isOnSale
        self._isFavorite = State(initialValue: isFavorite)
    }

    var body: some View {
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .fill(.ultraThinMaterial.opacity(0.2))
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                )
            
            VStack(alignment: .leading, spacing: 0) {
                // 헤더(이미지)
                headerSection
                    .frame(height: imageHeight)
                    .clipped()
                    .clipShape(.rect(
                        cornerRadii: .init(topLeading: cornerRadius, topTrailing: cornerRadius),
                        style: .continuous
                    ))
                    .overlay(alignment: .topLeading) {
                        HStack {
                            SalesStatusChip(isOnSale: isOnSale)
                                .padding(8)
                            Spacer()
                            Image(systemName: isFavorite ? "heart.fill" : "heart")
                                .foregroundColor(isFavorite ? .red : .gray)
                                .padding(.trailing, 6)
                                .onTapGesture { isFavorite.toggle() }
                        }
                        .padding(.horizontal, 4)
                    }

                // 정보 섹션
                infoSection
                    .padding(.horizontal, 12)
                    .padding(.bottom, 2)
                
            }
        }
        .shadow(radius: 3)
        .padding(.horizontal, 8)
    }

    // MARK: - 이미지 빌더
    @ViewBuilder
    private var vehicleImage: some View {
        if let imageName {
            Image(imageName)
                .resizable()
                .scaledToFill()
        } else {
            Image("testImage3")
                .resizable()
                .scaledToFill()
        }
    }
    
    // MARK: - 정보 섹션
    private var infoSection: some View {
        VStack(alignment: .leading, spacing: 2) {
            // 제목
            HStack {
                Text(title)
                    .font(.headline)
                    .bold()
                    .foregroundColor(.white)
                Spacer()
            }
            .padding(.top, 10)

            // 가격
            Text(price)
                .font(.title3.bold())
                .foregroundColor(AppColors.brandOrange)

            HStack(spacing: 10) {
                Label(location, systemImage: "map")
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Label(year, systemImage: "calendar")
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Label(mileage, systemImage: "speedometer")
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Label(fuelType, systemImage: "fuelpump")
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Label(transmission, systemImage: "gearshape")
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .labelStyle(CustomLabelStyle(spacing: 4))
            .font(.system(size: 10))
            .foregroundColor(.white.opacity(0.7))
            .padding(.bottom, 4)
        }
    }

    // MARK: - 헤더 섹션
    private var headerSection: some View {
        ZStack {
            Color.clear
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            if imageName != nil || thumbnailURL != nil {
                vehicleImage
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipped()
            }
        }
    }
}

// MARK: - 미리보기
struct VehicleCardView_Previews: PreviewProvider {
    static var previews: some View {
        VehicleCardView(
            vehicle: Vehicle(
                id: "preview-1",
                imageName: "testImage3",
                thumbnailURL: nil,
                title: "기아 K5",
                price: "3,200만원",
                year: "2023년",
                mileage: "8,000km",
                fuelType: "가솔린",
                transmission: "자동",
                location: "서울 서초구",
                status: .sold,
                postedDate: nil,
                isOnSale: false,
                isFavorite: true
            )
        )
        .background(Color.black)
    }
}
