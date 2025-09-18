//
//  Header.swift
//  campick
//
//  Created by Admin on 9/18/25.
//

import SwiftUI

struct Header: View {
    @Binding var showSlideMenu: Bool
    var body: some View {
        HStack {
            Text("Campick")
                .font(.custom("Pacifico", size: 30))
                .foregroundColor(.white)
                .shadow(radius: 2)
            
            Spacer()
            
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    showSlideMenu = true
                }
            }) {
                Image(systemName: "person")
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(AppColors.brandOrange)
                    .clipShape(Circle())
            }
        }
        .padding()
        .background(AppColors.brandBackground)
    }
}
