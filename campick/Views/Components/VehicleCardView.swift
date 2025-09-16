//
//  VehicleCardView.swift
//  campick
//
//  Created by Admin on 9/16/25.
//

import SwiftUI

struct VehicleCardView: View {
    // MARK: - Stored properties used for rendering
    private let imageName: String?
    private let thumbnailURL: URL?
    private let title: String
    private let price: String
    private let year: String
    private let mileage: String
    private let fuelType: String
    private let transmission: String
    private let location: String
    @State private var isFavorite: Bool

    // MARK: - Design constants
    private let cornerRadius: CGFloat = 12
    private let imageHeight: CGFloat = 180

    // MARK: - Initializers
    // 1) Model-based initializer (backwards compatible)
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
        self._isFavorite = State(initialValue: vehicle.isFavorite)
    }

    // 2) Parameter-based convenience initializer for mock/loose data
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
        self._isFavorite = State(initialValue: isFavorite)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // 차량 이미지
            ZStack(alignment: .top) {
                vehicleImage
                    .frame(height: imageHeight)
                    .clipped()
                    .clipShape(.rect(
                        cornerRadii: .init(topLeading: cornerRadius, topTrailing: cornerRadius),
                        style: .continuous
                    ))

                // 판매중 배지와 하트 아이콘
                HStack {
                    Text("판매중")
                        .font(.caption.bold())
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(AppColors.brandLightGreen)
                        .clipShape(Capsule())
                        .padding(8)
                    Spacer()
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(isFavorite ? .red : .gray)
                        .padding(8)
                        .onTapGesture { isFavorite.toggle() }
                }
            }

            // 차량 정보
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                }

                Text(price)
                    .font(.title3.bold())
                    .foregroundColor(AppColors.brandOrange)

                HStack(spacing: 16) {
                    Label(year, systemImage: "calendar")
                    Label(mileage, systemImage: "speedometer")
                    Label(fuelType, systemImage: "fuelpump")
                    Label(transmission, systemImage: "gearshape")
                }
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))

                HStack {
                    Image(systemName: "mappin.and.ellipse")
                    Text(location)
                }
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
            }
            .padding(12)
            .background(Color.white.opacity(0.12))
            .clipShape(.rect(
                cornerRadii: .init(bottomLeading: cornerRadius, bottomTrailing: cornerRadius),
                style: .continuous
            ))
        }
        .shadow(radius: 3)
        .padding(.horizontal, 8)
    }

    // MARK: - Image builder
    @ViewBuilder
    private var vehicleImage: some View {
        if let imageName {
            Image(imageName)
                .resizable()
                .scaledToFill()
        } else if let thumbnailURL {

            AsyncImage(url: thumbnailURL) { phase in
                switch phase {
                case .empty:
                    ZStack { Color.white.opacity(0.08); ProgressView() }
                case .success(let image):
                    image.resizable().scaledToFill()
                case .failure:
                    ZStack {
                        Color.white.opacity(0.08)
                        Image(systemName: "car")
                            .font(.system(size: 28, weight: .semibold))
                            .foregroundStyle(.white.opacity(0.7))
                    }
                @unknown default:
                    Color.white.opacity(0.08)
                }
            }
        } else {
            ZStack {
                Color.white.opacity(0.08)
                Image(systemName: "car")
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.7))
            }
        }
    }
}

// MARK: - Model
struct Vehicle {
    let imageName: String?
    let thumbnailURL: URL?
    let title: String
    let price: String
    let year: String
    let mileage: String
    let fuelType: String
    let transmission: String
    let location: String
    let isFavorite: Bool
}

// MARK: - Preview
struct VehicleCardView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 16) {
            VehicleCardView(
                vehicle: Vehicle(
                    imageName: "testImage3",
                    thumbnailURL: nil,
                    title: "기아 K5",
                    price: "3,200만원",
                    year: "2023년",
                    mileage: "8,000km",
                    fuelType: "가솔린",
                    transmission: "자동",
                    location: "서울 서초구",
                    isFavorite: true
                )
            )
            VehicleCardView(
                title: "현대 아반떼 N",
                price: "2,900만원",
                year: "2022년",
                mileage: "12,000km",
                fuelType: "가솔린",
                transmission: "자동",
                location: "부산",
                imageName: nil,
                thumbnailURL: URL(string: "https://picsum.photos/600/400"),
                isFavorite: false
            )
        }
        .background(Color.black)
        .padding()
    }
}

