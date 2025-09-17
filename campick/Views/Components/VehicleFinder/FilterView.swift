//
//  FilterView.swift
//  campick
//
//  Created by 김호집 on 9/17/25.
//

import SwiftUI

struct FilterOptions: Equatable {
    var priceRange: ClosedRange<Double> = 0...10000
    var mileageRange: ClosedRange<Double> = 0...100000
    var yearRange: ClosedRange<Double> = 2010...2024
    var selectedVehicleTypes: Set<String> = []
    var selectedFuelTypes: Set<String> = []
    var selectedTransmissions: Set<String> = []
}

struct FilterView: View {
    @Binding var filters: FilterOptions
    @Binding var isPresented: Bool

    @State private var tempFilters: FilterOptions

    let vehicleTypes = ["모터홈", "트레일러", "픽업캠퍼", "캠핑밴"]
    let fuelTypes = ["가솔린", "디젤", "LPG", "하이브리드", "전기"]
    let transmissions = ["자동", "수동", "CVT"]

    init(filters: Binding<FilterOptions>, isPresented: Binding<Bool>) {
        self._filters = filters
        self._isPresented = isPresented
        self._tempFilters = State(initialValue: filters.wrappedValue)
    }

    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture {
                    isPresented = false
                }
                .animation(nil, value: isPresented)

            VStack(spacing: 0) {
                headerView

                ScrollView {
                    VStack(spacing: 20) {
                        priceRangeSection
                        mileageRangeSection
                        yearRangeSection
                        vehicleTypesSection
                        fuelTypesSection
                        transmissionsSection
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }
                .frame(maxHeight: UIScreen.main.bounds.height * 0.5)
                
                footerView
            }
            .background(AppColors.background)
            .cornerRadius(12)
            .shadow(radius: 20)
            .frame(maxWidth: UIScreen.main.bounds.width - 32)
            .transition(.asymmetric(
                insertion: .move(edge: .bottom).combined(with: .opacity),
                removal: .move(edge: .bottom).combined(with: .opacity)
            ))
        }
        .onAppear {
            tempFilters = filters
        }
    }

    private var headerView: some View {
        HStack {
            Button("초기화") {
                resetFilters()
            }
            .foregroundColor(AppColors.brandOrange)
            .font(.system(size: 16, weight: .medium))

            Spacer()

            Text("필터")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)

            Spacer()

            Button(action: { isPresented = false }) {
                Image(systemName: "xmark")
                    .font(.system(size: 16))
                    .foregroundColor(.white.opacity(0.7))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.white.opacity(0.2)),
            alignment: .bottom
        )
    }

    private var priceRangeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("가격 (만원)")
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.white)

            VStack(spacing: 12) {
                RangeSlider(
                    range: $tempFilters.priceRange,
                    bounds: 0...10000,
                    step: 100
                )

                HStack {
                    Text("\(Int(tempFilters.priceRange.lowerBound).formatted(.number.locale(.current)))만원")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.6))

                    Spacer()

                    Text("\(Int(tempFilters.priceRange.upperBound).formatted(.number.locale(.current)))만원")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.6))
                }
            }
        }
    }

    private var mileageRangeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("주행거리 (km)")
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.white)

            VStack(spacing: 12) {
                RangeSlider(
                    range: $tempFilters.mileageRange,
                    bounds: 0...100000,
                    step: 5000
                )

                HStack {
                    Text("\(Int(tempFilters.mileageRange.lowerBound).formatted(.number.locale(.current)))km")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.6))

                    Spacer()

                    Text("\(Int(tempFilters.mileageRange.upperBound).formatted(.number.locale(.current)))km")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.6))
                }
            }
        }
    }

    private var yearRangeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("연식")
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.white)

            VStack(spacing: 12) {
                RangeSlider(
                    range: $tempFilters.yearRange,
                    bounds: 2010...2024,
                    step: 1
                )

                HStack {
                    Text("\(Int(tempFilters.yearRange.lowerBound))년")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.6))

                    Spacer()

                    Text("\(Int(tempFilters.yearRange.upperBound))년")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.6))
                }
            }
        }
    }

    private var vehicleTypesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("차량 종류")
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.white)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 2), spacing: 8) {
                ForEach(vehicleTypes, id: \.self) { type in
                    FilterChip(
                        title: type,
                        isSelected: tempFilters.selectedVehicleTypes.contains(type)
                    ) {
                        toggleSelection(in: &tempFilters.selectedVehicleTypes, item: type)
                    }
                }
            }
        }
    }

    private var fuelTypesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("연료")
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.white)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 2), spacing: 8) {
                ForEach(fuelTypes, id: \.self) { fuelType in
                    FilterChip(
                        title: fuelType,
                        isSelected: tempFilters.selectedFuelTypes.contains(fuelType)
                    ) {
                        toggleSelection(in: &tempFilters.selectedFuelTypes, item: fuelType)
                    }
                }
            }
        }
    }

    private var transmissionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("변속기")
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.white)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 2), spacing: 8) {
                ForEach(transmissions, id: \.self) { transmission in
                    FilterChip(
                        title: transmission,
                        isSelected: tempFilters.selectedTransmissions.contains(transmission)
                    ) {
                        toggleSelection(in: &tempFilters.selectedTransmissions, item: transmission)
                    }
                }
            }
        }
    }

    private var footerView: some View {
        VStack(spacing: 0) {
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.white.opacity(0.2))

            Button("적용하기") {
                applyFilters()
            }
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .background(AppColors.brandOrange)
            .foregroundColor(.white)
            .font(.system(size: 15, weight: .semibold))
            .cornerRadius(10)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
    }

    private func toggleSelection(in set: inout Set<String>, item: String) {
        if set.contains(item) {
            set.remove(item)
        } else {
            set.insert(item)
        }
    }

    private func resetFilters() {
        tempFilters = FilterOptions()
    }

    private func applyFilters() {
        filters = tempFilters
        isPresented = false
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(isSelected ? .white : .white.opacity(0.7))
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? AppColors.brandOrange : Color.white.opacity(0.1))
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct RangeSlider: View {
    @Binding var range: ClosedRange<Double>
    let bounds: ClosedRange<Double>
    let step: Double

    @State private var lowerValue: Double = 0
    @State private var upperValue: Double = 0

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background track
                Rectangle()
                    .fill(Color.white.opacity(0.2))
                    .frame(height: 8)
                    .cornerRadius(4)

                // Active track
                Rectangle()
                    .fill(AppColors.brandOrange)
                    .frame(width: activeTrackWidth(in: geometry), height: 8)
                    .cornerRadius(4)
                    .offset(x: activeTrackOffset(in: geometry))

                // Lower thumb
                Circle()
                    .fill(AppColors.brandOrange)
                    .frame(width: 20, height: 20)
                    .overlay(
                        Circle()
                            .stroke(AppColors.background, lineWidth: 3)
                    )
                    .offset(x: lowerThumbOffset(in: geometry))
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                updateLowerValue(from: value, in: geometry)
                            }
                    )

                // Upper thumb
                Circle()
                    .fill(AppColors.brandOrange)
                    .frame(width: 20, height: 20)
                    .overlay(
                        Circle()
                            .stroke(AppColors.background, lineWidth: 3)
                    )
                    .offset(x: upperThumbOffset(in: geometry))
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                updateUpperValue(from: value, in: geometry)
                            }
                    )
            }
        }
        .frame(height: 20)
        .onAppear {
            lowerValue = range.lowerBound
            upperValue = range.upperBound
        }
        .onChange(of: range) { _, newRange in
            lowerValue = newRange.lowerBound
            upperValue = newRange.upperBound
        }
    }

    private func lowerThumbOffset(in geometry: GeometryProxy) -> CGFloat {
        let percent = (lowerValue - bounds.lowerBound) / (bounds.upperBound - bounds.lowerBound)
        return percent * (geometry.size.width - 20)
    }

    private func upperThumbOffset(in geometry: GeometryProxy) -> CGFloat {
        let percent = (upperValue - bounds.lowerBound) / (bounds.upperBound - bounds.lowerBound)
        return percent * (geometry.size.width - 20)
    }

    private func activeTrackOffset(in geometry: GeometryProxy) -> CGFloat {
        let percent = (lowerValue - bounds.lowerBound) / (bounds.upperBound - bounds.lowerBound)
        return percent * (geometry.size.width - 20) + 10
    }

    private func activeTrackWidth(in geometry: GeometryProxy) -> CGFloat {
        let lowerPercent = (lowerValue - bounds.lowerBound) / (bounds.upperBound - bounds.lowerBound)
        let upperPercent = (upperValue - bounds.lowerBound) / (bounds.upperBound - bounds.lowerBound)
        return (upperPercent - lowerPercent) * (geometry.size.width - 20)
    }

    private func updateLowerValue(from gesture: DragGesture.Value, in geometry: GeometryProxy) {
        let percent = min(max(0, gesture.location.x / geometry.size.width), 1)
        let newValue = bounds.lowerBound + percent * (bounds.upperBound - bounds.lowerBound)
        let steppedValue = round(newValue / step) * step

        lowerValue = min(steppedValue, upperValue)
        range = lowerValue...upperValue
    }

    private func updateUpperValue(from gesture: DragGesture.Value, in geometry: GeometryProxy) {
        let percent = min(max(0, gesture.location.x / geometry.size.width), 1)
        let newValue = bounds.lowerBound + percent * (bounds.upperBound - bounds.lowerBound)
        let steppedValue = round(newValue / step) * step

        upperValue = max(steppedValue, lowerValue)
        range = lowerValue...upperValue
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    FilterView(
        filters: .constant(FilterOptions()),
        isPresented: .constant(true)
    )
}
