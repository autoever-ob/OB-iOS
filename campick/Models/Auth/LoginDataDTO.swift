import Foundation

struct LoginDataDTO: Decodable {
    let accessToken: String
    let refreshToken: String?
}

