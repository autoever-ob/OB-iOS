import Foundation

extension Notification.Name {
    /// 토큰 재발급 실패 시 사용자에게 재로그인을 요청하기 위한 알림
    static let tokenReissueFailed = Notification.Name("campick.tokenReissueFailed")
}
