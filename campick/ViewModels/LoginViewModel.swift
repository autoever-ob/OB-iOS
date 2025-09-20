import Foundation
import SwiftUI

@MainActor
final class LoginViewModel: ObservableObject {
    // Inputs
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var keepLoggedIn: Bool = false

    // UI State
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var showServerAlert: Bool = false
    @Published var showSignupPrompt: Bool = false

    var isLoginDisabled: Bool { email.isEmpty || password.isEmpty || isLoading }

    func login() {
        guard !isLoginDisabled else { return }
        isLoading = true
        errorMessage = nil
        showServerAlert = false
        showSignupPrompt = false
        Task {
            defer { isLoading = false }
            do {
                let res = try await AuthAPI.login(email: email, password: password)
                TokenManager.shared.saveAccessToken(res.accessToken)

                // 서버 로그인 응답에 user 정보가 없을 수 있어 안전 매핑
                let u = res.user
                let name = u?.name ?? u?.nickname ?? ""
                let nick = u?.nickname ?? u?.name ?? ""
                let phone = u?.mobileNumber ?? ""
                let memberId = u?.memberId ?? u?.id ?? ""
                let dealerId = u?.dealerId ?? ""
                let role = u?.role ?? ""

                UserState.shared.saveUserData(
                    name: name,
                    nickName: nick,
                    phoneNumber: phone,
                    memberId: memberId,
                    dealerId: dealerId,
                    role: role
                )
            } catch {
                if let appError = error as? AppError {
                    switch appError {
                    case .notFound:
                        errorMessage = nil
                        showSignupPrompt = true
                    case .cannotConnect, .hostNotFound, .network:
                        errorMessage = appError.message
                        showServerAlert = true
                    default:
                        errorMessage = appError.message
                    }
                } else {
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
}
