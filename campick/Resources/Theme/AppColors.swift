//
//  AppColors.swift
//  campick
//
//  Created by Admin on 9/15/25.
//

import SwiftUI

enum AppColors {
    /// 화면 공통 배경
    static let background = Color(hex: "0B211A")
    /// 기본 텍스트
    static let primaryText = Color.white
    
    static let brandOrange = Color(hex: "#F97316")
    static let brandLightOrange = Color(hex:"FB923C")
    static let brandLightGreen = Color(hex: "22C55E")
    static let brandBackground = Color(hex: "#0B211A")
    
    // 색상과 숫자가 같이 있는 경우는 해당 색상에 투명도(n)이 적용된 것임
    static let brandWhite70 = Color.white.opacity(0.7)
}
