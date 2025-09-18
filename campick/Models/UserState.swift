//
//  UserState.swift
//  campick
//
//  Created by 김호집 on 9/18/25.
//

import Foundation
import Combine

class UserState: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var name: String = ""
    @Published var nickName: String = ""
    @Published var phoneNumber: String = ""
    @Published var memberId: String = ""
    @Published var dealerId: String = ""
    @Published var role: String = ""

    static let shared = UserState()

    private init() {
        loadUserData()
    }

    func loadUserData() {
        name = UserDefaultsManager.getString(forKey: "name") ?? ""
        nickName = UserDefaultsManager.getString(forKey: "nickName") ?? ""
        phoneNumber = UserDefaultsManager.getString(forKey: "phoneNumber") ?? ""
        memberId = UserDefaultsManager.getString(forKey: "memberId") ?? ""
        dealerId = UserDefaultsManager.getString(forKey: "dealerId") ?? ""
        role = UserDefaultsManager.getString(forKey: "role") ?? ""

        // Check if user has valid token
        let hasAccessToken = KeychainManager.getToken(forKey: "accessToken") != nil

        isLoggedIn = hasAccessToken && !memberId.isEmpty
    }

    func saveUserData(name: String, nickName: String, phoneNumber: String, memberId: String, dealerId: String, role: String) {
        self.name = name
        self.nickName = nickName
        self.phoneNumber = phoneNumber
        self.memberId = memberId
        self.dealerId = dealerId
        self.role = role

        UserDefaultsManager.setString(name, forKey: "name")
        UserDefaultsManager.setString(nickName, forKey: "nickName")
        UserDefaultsManager.setString(phoneNumber, forKey: "phoneNumber")
        UserDefaultsManager.setString(memberId, forKey: "memberId")
        UserDefaultsManager.setString(dealerId, forKey: "dealerId")
        UserDefaultsManager.setString(role, forKey: "role")

        isLoggedIn = true
    }

    func saveToken(accessToken: String) {
        KeychainManager.saveToken(accessToken, forKey: "accessToken")

        if !memberId.isEmpty {
            isLoggedIn = true
        }
    }

    func logout() {
        // Clear keychain token
        KeychainManager.deleteToken(forKey: "accessToken")

        // Clear local storage
        UserDefaultsManager.removeValue(forKey: "name")
        UserDefaultsManager.removeValue(forKey: "nickName")
        UserDefaultsManager.removeValue(forKey: "phoneNumber")
        UserDefaultsManager.removeValue(forKey: "memberId")
        UserDefaultsManager.removeValue(forKey: "dealerId")
        UserDefaultsManager.removeValue(forKey: "role")

        // Clear state
        name = ""
        nickName = ""
        phoneNumber = ""
        memberId = ""
        dealerId = ""
        role = ""
        isLoggedIn = false
    }
}