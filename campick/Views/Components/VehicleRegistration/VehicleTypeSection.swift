//
//  VehicleTypeSection.swift
//  campick
//
//  Created by 김호집 on 9/17/25.
//

import SwiftUI

struct VehicleTypeSection: View {
    @Binding var vehicleType: String
    @Binding var showingVehicleTypePicker: Bool
    let errors: [String: String]

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            FieldLabel(text: "차량 종류")

            Button(action: { showingVehicleTypePicker = true }) {
                StyledInputContainer(hasError: errors["vehicleType"] != nil) {
                    HStack {
                        if let selectedType = vehicleTypes.first(where: { $0.value == vehicleType }) {
                            Image(systemName: selectedType.iconName)
                                .foregroundColor(AppColors.brandOrange)
                                .font(.system(size: 14))

                            Text(selectedType.label)
                                .foregroundColor(.white)
                                .font(.system(size: 14))
                        } else {
                            Text("차량 종류를 선택하세요")
                                .foregroundColor(.white.opacity(0.4))
                                .font(.system(size: 14))
                        }

                        Spacer()

                        Image(systemName: "chevron.down")
                            .foregroundColor(.white.opacity(0.4))
                            .font(.system(size: 12))
                    }
                    .padding(.horizontal, 12)
                }
            }

            ErrorText(message: errors["vehicleType"])
        }
    }
}