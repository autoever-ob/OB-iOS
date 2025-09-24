import Foundation

// MARK: - Domain Entities

struct AuthTokens {
    let accessToken: String
    let refreshToken: String?
}

struct UserProfileDomainModel {
    let id: String
    let memberId: String
    let name: String
    let nickname: String
    let phoneNumber: String
    let dealerId: String
    let role: String
    let email: String
    let profileImageUrl: String
    let profileThumbnailUrl: String
    let joinDate: String
}

struct AuthSession {
    let tokens: AuthTokens
    /// 정상적으로 디코딩된 사용자 정보가 있는 경우
    let user: UserProfileDomainModel?
    /// 서버가 별도 필드로 내려주는 보조 정보
    let fallback: AuthSessionFallback
}

struct AuthSessionFallback {
    let memberId: String?
    let dealerId: String?
    let profileImageUrl: String?
    let profileThumbnailUrl: String?
    let phoneNumber: String?
    let role: String?
    let nickname: String?
}

struct SignupPayload {
    let email: String
    let password: String
    let confirmPassword: String
    let nickname: String
    let mobileNumber: String
    let role: String
    let dealershipName: String
    let dealershipRegistrationNumber: String
}

struct PasswordResetPayload {
    let email: String
    let newPassword: String
}

// MARK: - Domain Helpers

extension AuthSession {
    /// fallback 데이터와 조합해 표현용 유저 객체를 생성합니다.
    func resolvedUser(emailFallback: String) -> UserProfileDomainModel {
        if let user {
            return UserProfileDomainModel(
                id: firstNonEmpty(user.id, fallback.memberId),
                memberId: firstNonEmpty(user.memberId, fallback.memberId),
                name: firstNonEmpty(user.name, fallback.nickname),
                nickname: firstNonEmpty(user.nickname, fallback.nickname),
                phoneNumber: firstNonEmpty(user.phoneNumber, fallback.phoneNumber),
                dealerId: firstNonEmpty(user.dealerId, fallback.dealerId),
                role: firstNonEmpty(user.role, fallback.role),
                email: firstNonEmpty(user.email, emailFallback),
                profileImageUrl: firstNonEmpty(user.profileImageUrl, fallback.profileImageUrl, fallback.profileThumbnailUrl),
                profileThumbnailUrl: firstNonEmpty(user.profileThumbnailUrl, fallback.profileThumbnailUrl, fallback.profileImageUrl),
                joinDate: user.joinDate
            )
        }
        return UserProfileDomainModel(
            id: fallback.memberId ?? "",
            memberId: fallback.memberId ?? "",
            name: fallback.nickname ?? "",
            nickname: fallback.nickname ?? "",
            phoneNumber: fallback.phoneNumber ?? "",
            dealerId: fallback.dealerId ?? "",
            role: fallback.role ?? "",
            email: firstNonEmpty(nil, emailFallback),
            profileImageUrl: firstNonEmpty(fallback.profileImageUrl, fallback.profileThumbnailUrl),
            profileThumbnailUrl: firstNonEmpty(fallback.profileThumbnailUrl, fallback.profileImageUrl),
            joinDate: ""
        )
    }
}

private func firstNonEmpty(_ values: String?...) -> String {
    for value in values {
        if let value, !value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return value
        }
    }
    return ""
}
