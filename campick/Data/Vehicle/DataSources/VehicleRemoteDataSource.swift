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
        do {
            let request = APIService.shared
                .request(Endpoint.carRecommend.url, method: .get)
                .validate()
            let wrapped = try await request.serializingDecodable(ApiResponse<VehicleResponse>.self).value
            if let data = wrapped.data {
                return data
            }
            throw NSError(
                domain: "VehicleRecommendError",
                code: wrapped.status ?? -1,
                userInfo: [NSLocalizedDescriptionKey: wrapped.message ?? "추천 차량을 불러오지 못했습니다."]
            )
        } catch {
            throw ErrorMapper.map(error)
        }
    }

    func toggleLike(productId: String) async throws {
        try await ProductAPI.likeProduct(productId: productId)
    }

    func fetchProducts(page: Int, size: Int, filter: ProductFilterRequest?, sort: ProductSort?) async throws -> Page<ProductItemDTO> {
        do {
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

            let request = APIService.shared.request(
                Endpoint.products.url,
                method: .get,
                parameters: params,
                encoding: URLEncoding(destination: .methodDependent, arrayEncoding: .noBrackets, boolEncoding: .literal)
            ).validate()

            let wrapped = try await request.serializingDecodable(ApiResponse<Page<ProductItemDTO>>.self).value
            return wrapped.data ?? Page(content: [], totalPages: 0, totalElements: 0, last: true, number: 0, size: size)
        } catch {
            throw ErrorMapper.map(error)
        }
    }

    func fetchProductDetail(productId: String) async throws -> ProductDetailDTO {
        try await ProductAPI.fetchProductDetail(productId: productId)
    }

    func updateProductStatus(productId: String, status: VehicleStatus) async throws -> ApiResponse<String> {
        try await ProductAPI.updateProductStatus(productId: productId, status: status)
    }

    func fetchFavorites(memberId: String, page: Int, size: Int) async throws -> MyProductListPageData {
        do {
            let params: [String: Any] = ["page": page, "size": size]
            let request = APIService.shared
                .request(Endpoint.favorites(memberId: memberId).url, method: .get, parameters: params, encoding: URLEncoding.default)
                .validate()
            let wrapped = try await request.serializingDecodable(ApiResponse<MyProductListPageData>.self).value
            if let data = wrapped.data {
                return data
            }
            throw NSError(
                domain: "FavoritesAPI",
                code: wrapped.status ?? -1,
                userInfo: [NSLocalizedDescriptionKey: wrapped.message ?? "찜 목록을 불러오지 못했습니다."]
            )
        } catch {
            throw ErrorMapper.map(error)
        }
    }

    func fetchProductInfo() async throws -> ProductInfoResponse {
        do {
            let request = APIService.shared
                .request(Endpoint.productInfo.url, method: .get)
                .validate()
            let wrapped = try await request.serializingDecodable(ProductInfoApiResponse.self).value
            if wrapped.success, let data = wrapped.data {
                return data
            }
            throw NSError(
                domain: "ProductInfoError",
                code: wrapped.status,
                userInfo: [NSLocalizedDescriptionKey: wrapped.message]
            )
        } catch {
            throw ErrorMapper.map(error)
        }
    }

    func createProduct(_ request: VehicleRegistrationRequest) async throws -> ApiResponse<Int> {
        try await ProductAPI.createProduct(request)
    }

    func updateProduct(productId: String, request: VehicleRegistrationRequest) async throws -> ApiResponse<Int> {
        try await ProductAPI.updateProduct(productId: productId, body: request)
    }
}
