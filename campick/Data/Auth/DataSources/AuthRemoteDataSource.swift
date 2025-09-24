import Foundation

protocol AuthRemoteDataSource {
    func login(email: String, password: String) async throws -> AuthResponse
    func signup(_ payload: SignupPayload) async throws -> AuthResponse?
    func sendEmailVerification(email: String) async throws
    func confirmEmailVerification(code: String) async throws
    func sendPasswordResetLink(email: String) async throws
    func verifyPasswordResetCode(code: String) async throws
    func resetPassword(_ payload: PasswordResetPayload) async throws
    func logout() async throws
}

final class DefaultAuthRemoteDataSource: AuthRemoteDataSource {
    func login(email: String, password: String) async throws -> AuthResponse {
        try await AuthAPI.login(email: email, password: password)
    }

    func signup(_ payload: SignupPayload) async throws -> AuthResponse? {
        try await AuthAPI.signupAllowingEmpty(
            email: payload.email,
            password: payload.password,
            checkedPassword: payload.confirmPassword,
            nickname: payload.nickname,
            mobileNumber: payload.mobileNumber,
            role: payload.role,
            dealershipName: payload.dealershipName,
            dealershipRegistrationNumber: payload.dealershipRegistrationNumber
        )
    }

    func sendEmailVerification(email: String) async throws {
        try await AuthAPI.sendEmailCode(email: email)
    }

    func confirmEmailVerification(code: String) async throws {
        try await AuthAPI.confirmEmailCode(code: code)
    }

    func sendPasswordResetLink(email: String) async throws {
        try await AuthAPI.sendPasswordResetLink(email: email)
    }

    func verifyPasswordResetCode(code: String) async throws {
        try await AuthAPI.passwordResetVerify(code: code)
    }

    func resetPassword(_ payload: PasswordResetPayload) async throws {
        _ = try await AuthAPI.passwordResetChange(email: payload.email, password: payload.newPassword)
    }

    func logout() async throws {
        try await AuthAPI.logout()
    }
}
