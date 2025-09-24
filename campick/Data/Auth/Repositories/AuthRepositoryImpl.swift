import Foundation

final class AuthRepositoryImpl: AuthRepository {
    private let remote: AuthRemoteDataSource

    init(remote: AuthRemoteDataSource) {
        self.remote = remote
    }

    func login(email: String, password: String) async throws -> AuthSession {
        let response = try await remote.login(email: email, password: password)
        return mapResponseToSession(response)
    }

    func signup(_ payload: SignupPayload) async throws -> AuthSession? {
        guard let response = try await remote.signup(payload) else { return nil }
        return mapResponseToSession(response)
    }

    func sendEmailVerification(email: String) async throws {
        try await remote.sendEmailVerification(email: email)
    }

    func confirmEmailVerification(code: String) async throws {
        try await remote.confirmEmailVerification(code: code)
    }

    func sendPasswordResetLink(email: String) async throws {
        try await remote.sendPasswordResetLink(email: email)
    }

    func verifyPasswordResetCode(code: String) async throws {
        try await remote.verifyPasswordResetCode(code: code)
    }

    func resetPassword(_ payload: PasswordResetPayload) async throws {
        try await remote.resetPassword(payload)
    }

    func logout() async throws {
        try await remote.logout()
    }

    // MARK: - Mapping
    private func mapResponseToSession(_ response: AuthResponse) -> AuthSession {
        let tokens = AuthTokens(accessToken: response.accessToken, refreshToken: response.refreshToken)
        let fallback = AuthSessionFallback(
            memberId: response.memberId,
            dealerId: response.dealerId,
            profileImageUrl: response.profileImageUrl,
            profileThumbnailUrl: response.profileThumbnailUrl,
            phoneNumber: response.phoneNumber,
            role: response.role,
            nickname: response.nickname
        )

        let userProfile: UserProfileDomainModel?
        if let dto = response.user {
            userProfile = UserProfileDomainModel(
                id: pickNonEmpty(dto.id, dto.memberId, response.memberId),
                memberId: pickNonEmpty(dto.memberId, dto.id, response.memberId),
                name: pickNonEmpty(dto.name, dto.nickname, response.nickname),
                nickname: pickNonEmpty(dto.nickname, dto.name, response.nickname),
                phoneNumber: pickNonEmpty(dto.mobileNumber, response.phoneNumber),
                dealerId: pickNonEmpty(dto.dealerId, response.dealerId),
                role: pickNonEmpty(dto.role, response.role),
                email: pickNonEmpty(dto.email),
                profileImageUrl: pickNonEmpty(dto.resolvedProfileImageURL, response.profileImageUrl, response.profileThumbnailUrl),
                profileThumbnailUrl: pickNonEmpty(response.profileThumbnailUrl, dto.resolvedProfileImageURL, response.profileImageUrl),
                joinDate: pickNonEmpty(dto.createdAt)
            )
        } else {
            userProfile = nil
        }

        return AuthSession(tokens: tokens, user: userProfile, fallback: fallback)
    }

    private func pickNonEmpty(_ values: String?...) -> String {
        for value in values {
            if let value, !value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                return value
            }
        }
        return ""
    }
}
