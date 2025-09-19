import Foundation

struct ProductListDTO: Decodable {
    let content: [ProductItemDTO]
    // 기타 페이징 필드는 필요 시 확장
}

