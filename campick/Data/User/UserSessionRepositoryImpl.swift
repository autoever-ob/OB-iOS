import Foundation

final class UserSessionRepositoryImpl: UserSessionRepository {
    private let userState: UserState
    private let tokenManager: TokenManager

    init(userState: UserState = UserState.shared, tokenManager: TokenManager = TokenManager.shared) {
        self.userState = userState
        self.tokenManager = tokenManager
    }

    func save(session: AuthSession, emailFallback: String) async {
        tokenManager.saveAccessToken(session.tokens.accessToken)
        tokenManager.saveRefreshToken(session.tokens.refreshToken)

        let profile = session.resolvedUser(emailFallback: emailFallback)
        await MainActor.run {
            self.userState.saveUserData(
                name: profile.name,
                nickName: profile.nickname,
                phoneNumber: profile.phoneNumber,
                memberId: profile.memberId,
                dealerId: profile.dealerId,
                role: profile.role,
                email: profile.email,
                profileImageUrl: profile.profileImageUrl,
                joinDate: profile.joinDate
            )
        }
    }

    func clear() async {
        await MainActor.run {
            self.userState.logout()
        }
    }
}
