import Foundation

final class AuthDependencyContainer {
    static let shared = AuthDependencyContainer()

    private let authRepository: AuthRepository
    private let userSessionRepository: UserSessionRepository

    private init() {
        let remote = DefaultAuthRemoteDataSource()
        self.authRepository = AuthRepositoryImpl(remote: remote)
        self.userSessionRepository = UserSessionRepositoryImpl()
    }

    func loginUseCase() -> LoginUseCase {
        LoginUseCase(authRepository: authRepository, userSessionRepository: userSessionRepository)
    }

    func signupUseCase() -> SignupUseCase {
        SignupUseCase(repository: authRepository)
    }

    func sendEmailVerificationUseCase() -> SendEmailVerificationUseCase {
        SendEmailVerificationUseCase(repository: authRepository)
    }

    func confirmEmailVerificationUseCase() -> ConfirmEmailVerificationUseCase {
        ConfirmEmailVerificationUseCase(repository: authRepository)
    }

    func sendPasswordResetLinkUseCase() -> SendPasswordResetLinkUseCase {
        SendPasswordResetLinkUseCase(repository: authRepository)
    }

    func verifyPasswordResetCodeUseCase() -> VerifyPasswordResetCodeUseCase {
        VerifyPasswordResetCodeUseCase(repository: authRepository)
    }

    func changePasswordUseCase() -> ChangePasswordUseCase {
        ChangePasswordUseCase(repository: authRepository)
    }

    func logoutUseCase() -> LogoutUseCase {
        LogoutUseCase(authRepository: authRepository, userSessionRepository: userSessionRepository)
    }
}
