//
//  FormLabel.swift
//  campick
//
//  Created by Admin on 9/16/25.
//

import Foundation
import SwiftUI

struct FormLabel: View {
    let text: String
    
    var body: some View {
        Text(text)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.subheadline.weight(.semibold))
            .padding(.leading, 4)
    }
}
