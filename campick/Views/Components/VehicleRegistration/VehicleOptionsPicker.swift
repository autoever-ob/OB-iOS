//
//  VehicleOptionsPicker.swift
//  campick
//
//  Created by 김호집 on 9/17/25.
//

import SwiftUI

struct VehicleOptionsPicker: View {
    @Binding var vehicleOptions: [VehicleOption]
    @Binding var showingOptionsPicker: Bool

    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    ForEach(vehicleOptions.indices, id: \.self) { index in
                        Button(action: {
                            vehicleOptions[index].isInclude.toggle()
                        }) {
                            HStack {
                                Image(systemName: vehicleOptions[index].isInclude ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(vehicleOptions[index].isInclude ? AppColors.brandOrange : .white.opacity(0.4))
                                    .font(.system(size: 20))
                                    .frame(width: 24)

                                Text(vehicleOptions[index].optionName)
                                    .foregroundColor(.white)
                                    .font(.system(size: 16))

                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                            .background(AppColors.brandBackground.opacity(0.5))
                        }
                        .buttonStyle(PlainButtonStyle())

                        if index != vehicleOptions.count - 1 {
                            Divider()
                                .background(AppColors.primaryText.opacity(0.1))
                        }
                    }

                    Spacer()
                }
            }
            .navigationTitle("차량 옵션 선택")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("완료") {
                showingOptionsPicker = false
            })
        }
        .preferredColorScheme(.dark)
    }
}