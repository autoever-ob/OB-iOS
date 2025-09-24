//
//  HomeProfileViewModel.swift
//  campick
//
//  Created by Admin on 9/21/25.
//

import Foundation


final class HomeProfileViewModel: ObservableObject {
    private let logoutUseCase: LogoutUseCase

    @Published var totalUnreadCount: Int = 0
    @Published var isLoading: Bool = false
    
    init(logoutUseCase: LogoutUseCase = AuthDependencyContainer.shared.logoutUseCase()) {
        self.logoutUseCase = logoutUseCase
    }
    
    
    func logout() {
        Task {
            do {
                try await logoutUseCase.execute()
            } catch {
                let mapped = ErrorMapper.map(error)
                AppLog.error("Logout failed: \(mapped.message)", category: "AUTH")
            }
        }
    }

    
    func totalUnreadMessage() {
            isLoading = true
            ChatService.shared.getTotalUnreadMessage { [weak self] result in
                DispatchQueue.main.async {
                    self?.isLoading = false
                    switch result {
                    case .success(let count):
                        self?.totalUnreadCount = count
                    case .failure(let error):
                        print("총 안 읽은 메시지 조회 실패: \(error.localizedDescription)")
                        self?.totalUnreadCount = 0
                    }
                }
            }
        }
}
