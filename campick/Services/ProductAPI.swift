//
//  ProductAPI.swift
//  campick
//
//  Created by Assistant on 9/19/25.
//

import Foundation
import Alamofire

enum ProductAPI {
    static func fetchProducts(page: Int? = nil, size: Int? = nil) async throws -> ProductListDTO {
        do {
            var params: [String: Any] = [:]
            if let page = page { params["page"] = page }
            if let size = size { params["size"] = size }

            let parameters: [String: Any]? = params.isEmpty ? nil : params

            let request = APIService.shared
                .request(
                    Endpoint.products.url,
                    method: .get,
                    parameters: parameters,
                    encoding: URLEncoding.default
                )
                .validate()
            // 서버 응답: ApiResponse<ProductListDTO>
            let wrapped = try await request.serializingDecodable(ApiResponse<ProductListDTO>.self).value
            guard let list = wrapped.data else { return ProductListDTO(totalElements: 0, totalPages: 0, size: 0, content: [], number: 0, sort: ProductSortDTO(empty: true, sorted: false, unsorted: true), pageable: ProductPageableDTO(offset: 0, sort: ProductSortDTO(empty: true, sorted: false, unsorted: true), paged: true, pageNumber: 0, pageSize: 0, unpaged: true), numberOfElements: 0, first: true, last: true, empty: true) }
            return list
        } catch {
            throw ErrorMapper.map(error)
        }
    }
}
