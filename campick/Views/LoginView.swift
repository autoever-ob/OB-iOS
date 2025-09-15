//
//  Untitled.swift
//  campick
//
//  Created by Admin on 9/15/25.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        ZStack {
            AppColors.background
                .ignoresSafeArea()

            Text("Hello, Login!")
                .foregroundColor(AppColors.primaryText)
                .font(.title)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
