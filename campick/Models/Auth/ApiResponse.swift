import Foundation

struct ApiResponse<T: Decodable>: Decodable {
    let status: Int?
    let success: Bool?
    let message: String?
    let data: T?
}

