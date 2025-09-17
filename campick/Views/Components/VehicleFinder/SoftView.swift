//
//  SoftView.swift
//  campick
//
//  Created by 김호집 on 9/17/25.
//

import SwiftUI

enum SortOption: String, CaseIterable {
    case recentlyAdded = "최근 등록순"
    case lowPrice = "낮은 가격순"
    case highPrice = "높은 가격순"
    case lowMileage = "주행거리 짧은순"
    case newestYear = "최신 연식순"
}

struct SortView: View {
    @Binding var selectedSort: SortOption
    @Binding var isPresented: Bool

    var body: some View {
        ZStack {
            // Dark overlay - appears immediately
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture {
                    isPresented = false
                }
                .animation(nil, value: isPresented)

            VStack(spacing: 0) {
                headerView
                sortOptionsView
            }
            .background(AppColors.background)
            .cornerRadius(12)
            .shadow(radius: 20)
            .frame(maxWidth: UIScreen.main.bounds.width - 40)
            .transition(.asymmetric(
                insertion: .move(edge: .bottom).combined(with: .opacity),
                removal: .move(edge: .bottom).combined(with: .opacity)
            ))
        }
    }

    private var headerView: some View {
        HStack {
            Text("정렬")
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

    private var sortOptionsView: some View {
        VStack(spacing: 8) {
            ForEach(SortOption.allCases, id: \.self) { option in
                sortOptionRow(option)
            }
        }
        .padding(16)
    }

    private func sortOptionRow(_ option: SortOption) -> some View {
        Button(action: {
            selectedSort = option
            isPresented = false
        }) {
            HStack {
                Text(option.rawValue)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(selectedSort == option ? AppColors.brandOrange : .white)

                Spacer()

                if selectedSort == option {
                    Image(systemName: "checkmark")
                        .font(.system(size: 16))
                        .foregroundColor(AppColors.brandOrange)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .frame(maxWidth: .infinity)
            .background(
                selectedSort == option ? AppColors.brandOrange.opacity(0.1) : Color.clear
            )
            .cornerRadius(8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    SortView(
        selectedSort: .constant(.recentlyAdded),
        isPresented: .constant(true)
    )
}
