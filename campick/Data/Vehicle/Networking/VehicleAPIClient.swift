import Foundation
import Alamofire

struct VehicleAPIClient {
    private let session: Session

    init(session: Session = APIService.shared) {
        self.session = session
    }

    func requestDecodable<T: Decodable>(
        url: URLConvertible,
        method: HTTPMethod,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default
    ) async throws -> T {
        do {
            let request = session
                .request(url, method: method, parameters: parameters, encoding: encoding)
                .validate()
            return try await request.serializingDecodable(T.self).value
        } catch {
            throw ErrorMapper.map(error)
        }
    }

    func requestDecodable<T: Decodable, Body: Encodable>(
        url: URLConvertible,
        method: HTTPMethod,
        body: Body,
        encoder: ParameterEncoder
    ) async throws -> T {
        do {
            let request = session
                .request(url, method: method, parameters: body, encoder: encoder)
                .validate()
            return try await request.serializingDecodable(T.self).value
        } catch {
            throw ErrorMapper.map(error)
        }
    }

    func requestData(
        url: URLConvertible,
        method: HTTPMethod,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default
    ) async throws {
        do {
            let request = session
                .request(url, method: method, parameters: parameters, encoding: encoding)
                .validate()
            _ = try await request.serializingData().value
        } catch {
            throw ErrorMapper.map(error)
        }
    }
}
