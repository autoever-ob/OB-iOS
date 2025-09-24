import Foundation
import SwiftUI

@MainActor
final class LoginViewModel: ObservableObject {
    private let loginUseCase: LoginUseCase

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

    init(loginUseCase: LoginUseCase = AuthDependencyContainer.shared.loginUseCase()) {
        self.loginUseCase = loginUseCase
    }

    func login() {
        guard !isLoginDisabled else { return }
        isLoading = true
        errorMessage = nil
        showServerAlert = false
        showSignupPrompt = false
        Task {
            defer { isLoading = false }
            do {
                try await loginUseCase.execute(email: email, password: password, keepLoggedIn: keepLoggedIn)
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
