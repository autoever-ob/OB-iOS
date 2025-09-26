import XCTest
@testable import campick

final class AuthUseCaseTests: XCTestCase {

    func testLoginPersistsSessionUsingEmailFallback() async throws {
        let session = AuthSession.sample()
        let authRepository = AuthRepositoryMock(loginResult: session)
        let sessionRepository = UserSessionRepositoryMock()
        let useCase = LoginUseCase(authRepository: authRepository, userSessionRepository: sessionRepository)

        try await useCase.execute(email: "user@example.com", password: "password", keepLoggedIn: true)

        XCTAssertEqual(authRepository.loginCallCount, 1)
        XCTAssertEqual(authRepository.lastLoginCredentials?.email, "user@example.com")
        XCTAssertEqual(sessionRepository.savedSessions.count, 1)
        XCTAssertEqual(sessionRepository.savedSessions.first?.session.tokens.accessToken, "access-token")
        XCTAssertEqual(sessionRepository.savedSessions.first?.emailFallback, "user@example.com")
    }

    func testLogoutClearsSessionEvenWhenRepositoryThrows() async {
        let authRepository = AuthRepositoryMock(loginResult: AuthSession.sample())
        authRepository.logoutError = NSError(domain: "test", code: -1)
        let sessionRepository = UserSessionRepositoryMock()
        let useCase = LogoutUseCase(authRepository: authRepository, userSessionRepository: sessionRepository)

        await XCTAssertThrowsErrorAsync(try await useCase.execute())

        XCTAssertEqual(authRepository.logoutCallCount, 1)
        XCTAssertEqual(sessionRepository.clearCallCount, 1)
    }
}

// MARK: - Test Doubles

private final class AuthRepositoryMock: AuthRepository {
    struct LoginCredentials { let email: String; let password: String }

    var loginCallCount = 0
    var lastLoginCredentials: LoginCredentials?
    var loginResult: AuthSession?
    var loginError: Error?

    var signupResult: AuthSession?
    var logoutCallCount = 0
    var logoutError: Error?

    init(loginResult: AuthSession?, loginError: Error? = nil) {
        self.loginResult = loginResult
        self.loginError = loginError
    }

    func login(email: String, password: String) async throws -> AuthSession {
        loginCallCount += 1
        lastLoginCredentials = LoginCredentials(email: email, password: password)
        if let loginError { throw loginError }
        guard let loginResult else {
            throw MockError.unconfigured
        }
        return loginResult
    }

    func signup(_ payload: SignupPayload) async throws -> AuthSession? {
        signupResult
    }

    func sendEmailVerification(email: String) async throws {}

    func confirmEmailVerification(code: String) async throws {}

    func sendPasswordResetLink(email: String) async throws {}

    func verifyPasswordResetCode(code: String) async throws {}

    func resetPassword(_ payload: PasswordResetPayload) async throws {}

    func logout() async throws {
        logoutCallCount += 1
        if let logoutError { throw logoutError }
    }
}

private final class UserSessionRepositoryMock: UserSessionRepository {
    struct SavedSession {
        let session: AuthSession
        let emailFallback: String
    }

    private(set) var savedSessions: [SavedSession] = []
    private(set) var clearCallCount = 0

    func save(session: AuthSession, emailFallback: String) async {
        savedSessions.append(SavedSession(session: session, emailFallback: emailFallback))
    }

    func clear() async {
        clearCallCount += 1
    }
}

private enum MockError: Error { case unconfigured }

private extension AuthSession {
    static func sample() -> AuthSession {
        let tokens = AuthTokens(accessToken: "access-token", refreshToken: "refresh-token")
        let user = UserProfileDomainModel(
            id: "1",
            memberId: "m-1",
            name: "John Doe",
            nickname: "John",
            phoneNumber: "010-0000-0000",
            dealerId: "d-1",
            role: "USER",
            email: "user@example.com",
            profileImageUrl: "https://example.com/profile.png",
            profileThumbnailUrl: "https://example.com/profile-thumb.png",
            joinDate: "2023-01-01"
        )
        let fallback = AuthSessionFallback(
            memberId: "m-1",
            dealerId: "d-1",
            profileImageUrl: nil,
            profileThumbnailUrl: nil,
            phoneNumber: "010-0000-0000",
            role: "USER",
            nickname: "John"
        )
        return AuthSession(tokens: tokens, user: user, fallback: fallback)
    }
}

// MARK: - Async assertion helper

private extension XCTestCase {
    func XCTAssertThrowsErrorAsync(_ expression: @autoclosure () async throws -> Void, file: StaticString = #filePath, line: UInt = #line) async {
        do {
            try await expression()
            XCTFail("Expected error to be thrown", file: file, line: line)
        } catch {
            // expected
        }
    }
}
