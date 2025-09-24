import Foundation

protocol AuthRepository {
    func login(email: String, password: String) async throws -> AuthSession
    func signup(_ payload: SignupPayload) async throws -> AuthSession?
    func sendEmailVerification(email: String) async throws
    func confirmEmailVerification(code: String) async throws
    func sendPasswordResetLink(email: String) async throws
    func verifyPasswordResetCode(code: String) async throws
    func resetPassword(_ payload: PasswordResetPayload) async throws
    func logout() async throws
}

protocol UserSessionRepository {
    func save(session: AuthSession, emailFallback: String) async
    func clear() async
}
