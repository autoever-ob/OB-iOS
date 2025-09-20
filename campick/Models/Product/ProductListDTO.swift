import Foundation

struct ProductListDTO: Decodable {
    let totalElements: Int
    let totalPages: Int
    let size: Int
    let content: [ProductItemDTO]
    let number: Int
    let sort: ProductSortDTO
    let pageable: ProductPageableDTO
    let numberOfElements: Int
    let first: Bool
    let last: Bool
    let empty: Bool
}

struct ProductSortDTO: Decodable {
    let empty: Bool
    let sorted: Bool
    let unsorted: Bool
}

struct ProductPageableDTO: Decodable {
    let offset: Int
    let sort: ProductSortDTO
    let paged: Bool
    let pageNumber: Int
    let pageSize: Int
    let unpaged: Bool
}

