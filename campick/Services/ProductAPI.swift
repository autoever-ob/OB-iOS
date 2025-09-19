//
//  ProductAPI.swift
//  campick
//
//  Created by Assistant on 9/19/25.
//

import Foundation
import Alamofire

enum ProductAPI {
    static func fetchProducts(page: Int? = nil, size: Int? = nil) async throws -> [ProductItemDTO] {
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
            return wrapped.data?.content ?? []
        } catch {
            throw ErrorMapper.map(error)
        }
    }
}

