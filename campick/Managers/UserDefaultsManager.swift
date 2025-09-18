//
//  UserDefaultsManager.swift
//  campick
//
//  Created by 김호집 on 9/18/25.
//

import Foundation

class UserDefaultsManager {

    static func setString(_ value: String, forKey key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }

    static func getString(forKey key: String) -> String? {
        return UserDefaults.standard.string(forKey: key)
    }

    static func setBool(_ value: Bool, forKey key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }

    static func getBool(forKey key: String) -> Bool {
        return UserDefaults.standard.bool(forKey: key)
    }

    static func setInt(_ value: Int, forKey key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }

    static func getInt(forKey key: String) -> Int {
        return UserDefaults.standard.integer(forKey: key)
    }

    static func removeValue(forKey key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }

    static func clearAll() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
    }
}