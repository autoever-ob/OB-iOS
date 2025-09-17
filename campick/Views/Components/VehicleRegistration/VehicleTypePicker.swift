//
//  VehicleTypePicker.swift
//  campick
//
//  Created by 김호집 on 9/17/25.
//

import SwiftUI

struct VehicleTypePicker: View {
    @Binding var vehicleType: String
    @Binding var showingVehicleTypePicker: Bool
    @Binding var errors: [String: String]

    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    ForEach(vehicleTypes, id: \.value) { type in
                        Button(action: {
                            vehicleType = type.value
                            errors["vehicleType"] = nil
                            showingVehicleTypePicker = false
                        }) {
                            HStack {
                                Image(systemName: type.iconName)
                                    .foregroundColor(AppColors.brandOrange)
                                    .font(.system(size: 16))
                                    .frame(width: 24)

                                Text(type.label)
                                    .foregroundColor(.white)
                                    .font(.system(size: 16))

                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                            .background(AppColors.brandBackground.opacity(0.5))
                        }
                        .buttonStyle(PlainButtonStyle())

                        if type.value != vehicleTypes.last?.value {
                            Divider()
                                .background(AppColors.primaryText.opacity(0.1))
                        }
                    }

                    Spacer()
                }
            }
            .navigationTitle("차량 종류 선택")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("닫기") {
                showingVehicleTypePicker = false
            })
        }
        .preferredColorScheme(.dark)
    }
}