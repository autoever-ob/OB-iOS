//
//  ProfileView.swift
//  campick
//
//  Created by 김호집 on 9/16/25.
//

import SwiftUI

struct ProfileView: View {
    let userId: String
    let isOwnProfile: Bool

    @StateObject private var viewModel: ProfileViewViewModel
    @StateObject private var userState = UserState.shared
    @Environment(\.dismiss) private var dismiss

    init(userId: String, isOwnProfile: Bool) {
        self.userId = userId
        self.isOwnProfile = isOwnProfile
        self._viewModel = StateObject(wrappedValue: ProfileViewViewModel(userId: userId, isOwnProfile: isOwnProfile))
    }

    var body: some View {
        ZStack {
                AppColors.background
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                if viewModel.isOwnProfile {
                    CustomNavigationBar(
                        title: "내 프로필",
                        isOwnProfile: viewModel.isOwnProfile,
                        onEditTapped: {
                            viewModel.showEditModal = true
                        }
                    )
                }

                ScrollView {
                    VStack(spacing: 16) {
                        ProfileHeaderCompact(
                            userProfile: viewModel.userProfile,
                            isOwnProfile: viewModel.isOwnProfile
                        )
                        .padding(.horizontal, 16)
                        .padding(.top, 12)

                        TabNavigationCompact(
                            activeTab: $viewModel.activeTab,
                            tabs: ProfileViewViewModel.TabType.allCases
                        )
                        .padding(.horizontal, 16)

                        VehicleListingsCompact(
                            listings: viewModel.currentListings,
                            isOwnProfile: viewModel.isOwnProfile
                        )
                        .padding(.horizontal, 16)

                        if viewModel.isOwnProfile {
                            SettingsSection(viewModel: viewModel)
                                .padding(.horizontal, 16)
                                .padding(.top, 8)
                                .padding(.bottom, 100)
                        }
                    }
                }
                }
            }
            .navigationBarHidden(viewModel.isOwnProfile)
            .navigationTitle(viewModel.isOwnProfile ? "" : "판매자 프로필")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .sheet(isPresented: $viewModel.showEditModal) {
                ProfileEditModal(viewModel: viewModel)
            }
            .navigationDestination(isPresented: $viewModel.showPasswordChangeView) {
                PasswordChangeView()
            }
            .overlay(
                ZStack {
                    if viewModel.showLogoutModal {
                        LogoutModal(
                            onConfirm: {
                                viewModel.showLogoutModal = false
                                viewModel.logout()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                }
                            },
                            onCancel: {
                                viewModel.showLogoutModal = false
                            }
                        )
                        .zIndex(1)
                    }

                    if viewModel.showWithdrawalModal {
                        WithdrawalModal(
                            onConfirm: {
                                viewModel.showWithdrawalModal = false
                                viewModel.confirmDeleteAccount()
                            },
                            onCancel: {
                                viewModel.showWithdrawalModal = false
                            }
                        )
                        .zIndex(1)
                    }
                }
            )
    }
}


#Preview {
    ProfileView(userId: "1", isOwnProfile: true)
}
