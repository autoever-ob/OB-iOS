import Foundation
import Alamofire

protocol VehicleRemoteDataSource {
    func fetchRecommendations() async throws -> VehicleResponse
    func toggleLike(productId: String) async throws
    func fetchProducts(page: Int, size: Int, filter: ProductFilterRequest?, sort: ProductSort?) async throws -> Page<ProductItemDTO>
    func fetchProductDetail(productId: String) async throws -> ProductDetailDTO
    func updateProductStatus(productId: String, status: VehicleStatus) async throws -> ApiResponse<String>
    func fetchFavorites(memberId: String, page: Int, size: Int) async throws -> MyProductListPageData
    func fetchProductInfo() async throws -> ProductInfoResponse
    func createProduct(_ request: VehicleRegistrationRequest) async throws -> ApiResponse<Int>
    func updateProduct(productId: String, request: VehicleRegistrationRequest) async throws -> ApiResponse<Int>
}

struct DefaultVehicleRemoteDataSource: VehicleRemoteDataSource {
    func fetchRecommendations() async throws -> VehicleResponse {
        let wrapped: ApiResponse<VehicleResponse> = try await decodableRequest(
            url: Endpoint.carRecommend.url,
            method: .get
        )
        if let data = wrapped.data {
            return data
        }
        throw NSError(
            domain: "VehicleRecommendError",
            code: wrapped.status ?? -1,
            userInfo: [NSLocalizedDescriptionKey: wrapped.message ?? "추천 차량을 불러오지 못했습니다."]
        )
    }

    func toggleLike(productId: String) async throws {
        AppLog.info("Like product: \(productId)", category: "PRODUCT")
        try await dataRequest(
            url: Endpoint.productLike(productId: productId).url,
            method: .patch
        )
    }

    func fetchProducts(page: Int, size: Int, filter: ProductFilterRequest?, sort: ProductSort?) async throws -> Page<ProductItemDTO> {
        var params: [String: Any] = ["page": page, "size": size]
        if let filter {
            if let v = filter.mileageFrom { params["mileageFrom"] = v }
            if let v = filter.mileageTo { params["mileageTo"] = v }
            if let v = filter.costFrom { params["costFrom"] = v }
            if let v = filter.costTo { params["costTo"] = v }
            if let v = filter.generationFrom { params["generationFrom"] = v }
            if let v = filter.generationTo { params["generationTo"] = v }
            if let types = filter.types, !types.isEmpty {
                params["types"] = types
            }
        }
        if let sort { params["sort"] = sort.queryValue }

        let wrapped: ApiResponse<Page<ProductItemDTO>> = try await decodableRequest(
            url: Endpoint.products.url,
            method: .get,
            parameters: params,
            encoding: URLEncoding(destination: .methodDependent, arrayEncoding: .noBrackets, boolEncoding: .literal)
        )
        return wrapped.data ?? Page.empty(page: page, size: size)
    }

    func fetchProductDetail(productId: String) async throws -> ProductDetailDTO {
        let wrapped: ProductDetailResponse = try await decodableRequest(
            url: Endpoint.productDetail(productId: productId).url,
            method: .get
        )
        if let detail = wrapped.data {
            return detail
        }
        throw NSError(
            domain: "ProductDetailError",
            code: wrapped.status ?? -1,
            userInfo: [NSLocalizedDescriptionKey: wrapped.message ?? "상품 정보를 불러오지 못했습니다."]
        )
    }

    func updateProductStatus(productId: String, status: VehicleStatus) async throws -> ApiResponse<String> {
        AppLog.info("Update product status (id: \(productId), to: \(status))", category: "PRODUCT")
        let body: [String: Any] = [
            "productId": Int(productId) ?? 0,
            "status": status.apiValue
        ]
        return try await decodableRequest(
            url: Endpoint.productStatus.url,
            method: .patch,
            parameters: body,
            encoding: JSONEncoding.default
        )
    }

    func fetchFavorites(memberId: String, page: Int, size: Int) async throws -> MyProductListPageData {
        let params: [String: Any] = ["page": page, "size": size]
        let wrapped: ApiResponse<MyProductListPageData> = try await decodableRequest(
            url: Endpoint.favorites(memberId: memberId).url,
            method: .get,
            parameters: params,
            encoding: URLEncoding.default
        )
        if let data = wrapped.data {
            return data
        }
        throw NSError(
            domain: "FavoritesAPI",
            code: wrapped.status ?? -1,
            userInfo: [NSLocalizedDescriptionKey: wrapped.message ?? "찜 목록을 불러오지 못했습니다."]
        )
    }

    func fetchProductInfo() async throws -> ProductInfoResponse {
        let wrapped: ProductInfoApiResponse = try await decodableRequest(
            url: Endpoint.productInfo.url,
            method: .get
        )
        if wrapped.success, let data = wrapped.data {
            return data
        }
        throw NSError(
            domain: "ProductInfoError",
            code: wrapped.status,
            userInfo: [NSLocalizedDescriptionKey: wrapped.message]
        )
    }

    func createProduct(_ request: VehicleRegistrationRequest) async throws -> ApiResponse<Int> {
        AppLog.info("Creating product (title: \(request.title))", category: "PRODUCT")
        return try await decodableRequest(
            url: Endpoint.registerProduct.url,
            method: .post,
            body: request,
            encoder: JSONParameterEncoder.default
        )
    }

    func updateProduct(productId: String, request: VehicleRegistrationRequest) async throws -> ApiResponse<Int> {
        AppLog.info("Updating product (id: \(productId), title: \(request.title))", category: "PRODUCT")
        return try await decodableRequest(
            url: Endpoint.productDetail(productId: productId).url,
            method: .patch,
            body: request,
            encoder: JSONParameterEncoder.default
        )
    }
}

private extension VehicleStatus {
    var apiValue: String {
        switch self {
        case .active: return "AVAILABLE"
        case .reserved: return "RESERVED"
        case .sold: return "SOLD"
        }
    }
}

// MARK: - Private helpers

private extension DefaultVehicleRemoteDataSource {
    func decodableRequest<T: Decodable>(
        url: URLConvertible,
        method: HTTPMethod,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default
    ) async throws -> T {
        do {
            let request = APIService.shared
                .request(url, method: method, parameters: parameters, encoding: encoding)
                .validate()
            return try await request.serializingDecodable(T.self).value
        } catch {
            throw ErrorMapper.map(error)
        }
    }

    func decodableRequest<T: Decodable, Body: Encodable>(
        url: URLConvertible,
        method: HTTPMethod,
        body: Body,
        encoder: ParameterEncoder
    ) async throws -> T {
        do {
            let request = APIService.shared
                .request(url, method: method, parameters: body, encoder: encoder)
                .validate()
            return try await request.serializingDecodable(T.self).value
        } catch {
            throw ErrorMapper.map(error)
        }
    }

    func dataRequest(
        url: URLConvertible,
        method: HTTPMethod,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default
    ) async throws {
        do {
            let request = APIService.shared
                .request(url, method: method, parameters: parameters, encoding: encoding)
                .validate()
            _ = try await request.serializingData().value
        } catch {
            throw ErrorMapper.map(error)
        }
    }
}
