//
//  VehicleOptionsSection.swift
//  campick
//
//  Created by 김호집 on 9/17/25.
//

import SwiftUI

struct VehicleOptionsSection: View {
    @Binding var vehicleOptions: [VehicleOption]
    @Binding var showingOptionsPicker: Bool
    let errors: [String: String]

    var selectedOptionsText: String {
        let selectedOptions = vehicleOptions.filter { $0.isInclude }
        if selectedOptions.isEmpty {
            return "옵션을 선택하세요"
        }
        return selectedOptions.map { $0.optionName }.joined(separator: ", ")
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            FieldLabel(text: "차량 옵션")

            Button(action: { showingOptionsPicker = true }) {
                StyledInputContainer(hasError: errors["options"] != nil) {
                    HStack {
                        Text(selectedOptionsText)
                            .foregroundColor(vehicleOptions.contains { $0.isInclude } ? .white : .white.opacity(0.4))
                            .font(.system(size: 14))
                            .multilineTextAlignment(.leading)

                        Spacer()

                        Image(systemName: "chevron.down")
                            .foregroundColor(.white.opacity(0.4))
                            .font(.system(size: 12))
                    }
                    .padding(.horizontal, 12)
                }
            }

            ErrorText(message: errors["options"])
        }
    }
}