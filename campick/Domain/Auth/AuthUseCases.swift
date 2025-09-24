import Foundation

struct LoginUseCase {
    private let authRepository: AuthRepository
    private let userSessionRepository: UserSessionRepository

    init(authRepository: AuthRepository, userSessionRepository: UserSessionRepository) {
        self.authRepository = authRepository
        self.userSessionRepository = userSessionRepository
    }

    func execute(email: String, password: String, keepLoggedIn: Bool) async throws {
        _ = keepLoggedIn // Future: handle auto-login preference
        let session = try await authRepository.login(email: email, password: password)
        await userSessionRepository.save(session: session, emailFallback: email)
    }
}

struct SignupUseCase {
    private let repository: AuthRepository

    init(repository: AuthRepository) {
        self.repository = repository
    }

    func execute(_ payload: SignupPayload) async throws -> AuthSession? {
        try await repository.signup(payload)
    }
}

struct SendEmailVerificationUseCase {
    private let repository: AuthRepository

    init(repository: AuthRepository) {
        self.repository = repository
    }

    func execute(email: String) async throws {
        try await repository.sendEmailVerification(email: email)
    }
}

struct ConfirmEmailVerificationUseCase {
    private let repository: AuthRepository

    init(repository: AuthRepository) {
        self.repository = repository
    }

    func execute(code: String) async throws {
        try await repository.confirmEmailVerification(code: code)
    }
}

struct SendPasswordResetLinkUseCase {
    private let repository: AuthRepository

    init(repository: AuthRepository) {
        self.repository = repository
    }

    func execute(email: String) async throws {
        try await repository.sendPasswordResetLink(email: email)
    }
}

struct VerifyPasswordResetCodeUseCase {
    private let repository: AuthRepository

    init(repository: AuthRepository) {
        self.repository = repository
    }

    func execute(code: String) async throws {
        try await repository.verifyPasswordResetCode(code: code)
    }
}

struct ChangePasswordUseCase {
    private let repository: AuthRepository

    init(repository: AuthRepository) {
        self.repository = repository
    }

    func execute(email: String, newPassword: String) async throws {
        let payload = PasswordResetPayload(email: email, newPassword: newPassword)
        try await repository.resetPassword(payload)
    }
}

struct LogoutUseCase {
    private let authRepository: AuthRepository
    private let userSessionRepository: UserSessionRepository

    init(authRepository: AuthRepository, userSessionRepository: UserSessionRepository) {
        self.authRepository = authRepository
        self.userSessionRepository = userSessionRepository
    }

    func execute() async throws {
        do {
            try await authRepository.logout()
        } catch {
            await userSessionRepository.clear()
            throw error
        }
        await userSessionRepository.clear()
    }
}
