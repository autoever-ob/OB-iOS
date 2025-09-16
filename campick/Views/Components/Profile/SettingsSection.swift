//
//  SettingsSection.swift
//  campick
//
//  Created by 김호집 on 9/16/25.
//

import SwiftUI

struct SettingsSection: View {
    @ObservedObject var viewModel: ProfileViewViewModel

    var body: some View {
        VStack(spacing: 12) {
            Text("설정")
                .foregroundColor(.white)
                .font(.system(size: 17, weight: .semibold))
                .frame(maxWidth: .infinity, alignment: .leading)

            VStack(spacing: 8) {
                SettingsRow(title: "프로필 수정", icon: "person.crop.circle") {
                    viewModel.editProfile()
                }

                SettingsRow(title: "비밀번호 변경", icon: "lock") {
                    viewModel.changePassword()
                }

                SettingsRow(title: "로그아웃", icon: "arrow.right.square", isDestructive: true) {
                    viewModel.showLogoutModal = true
                }
                SettingsRow(title: "회원 탈퇴", icon: "xmark.circle", isDestructive: true) {
                    viewModel.deleteAccount()
                }
            }
            .padding(16)
            .background(Color.white.opacity(0.05))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

struct SettingsRow: View {
    let title: String
    let icon: String
    let isDestructive: Bool
    let action: () -> Void

    init(title: String, icon: String, isDestructive: Bool = false, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.isDestructive = isDestructive
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(isDestructive ? .red : .white.opacity(0.6))
                    .frame(width: 20)

                Text(title)
                    .foregroundColor(isDestructive ? .red : .white)
                    .font(.system(size: 15))

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.white.opacity(0.4))
                    .font(.system(size: 12))
            }
            .padding(.vertical, 8)
        }
    }
}

struct SettingsRowContent: View {
    let title: String
    let icon: String
    let isDestructive: Bool

    init(title: String, icon: String, isDestructive: Bool = false) {
        self.title = title
        self.icon = icon
        self.isDestructive = isDestructive
    }

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(isDestructive ? .red : .white.opacity(0.6))
                .frame(width: 20)

            Text(title)
                .foregroundColor(isDestructive ? .red : .white)
                .font(.system(size: 15))

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.white.opacity(0.4))
                .font(.system(size: 12))
        }
        .padding(.vertical, 6)
    }
}
