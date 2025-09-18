//
//  KeychainManager.swift
//  campick
//
//  Created by 김호집 on 9/18/25.
//

import Foundation
import Security

class KeychainManager {

    static func saveToken(_ token: String, forKey key: String) {
        let data = token.data(using: .utf8)!

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]

        SecItemDelete(query as CFDictionary)

        let status = SecItemAdd(query as CFDictionary, nil)

        if status != errSecSuccess {
        }
    }

    static func getToken(forKey key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

        if status == errSecSuccess {
            if let data = dataTypeRef as? Data,
               let token = String(data: data, encoding: .utf8) {
                return token
            }
        }

        return nil
    }

    static func deleteToken(forKey key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]

        let status = SecItemDelete(query as CFDictionary)

        if status != errSecSuccess && status != errSecItemNotFound {
        }
    }

    static func deleteAllTokens() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword
        ]

        SecItemDelete(query as CFDictionary)
    }
}