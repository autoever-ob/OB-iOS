import XCTest
import Alamofire
@testable import campick

final class VehicleAPIClientTests: XCTestCase {
    override func setUp() {
        super.setUp()
        URLProtocolStub.reset()
    }

    override func tearDown() {
        URLProtocolStub.reset()
        super.tearDown()
    }

    func testRequestDecodableReturnsDecodedModel() async throws {
        let expected = SampleResponse(name: "Mock")
        URLProtocolStub.responseData = try JSONEncoder().encode(expected)
        URLProtocolStub.response = HTTPURLResponse(
            url: sampleURL,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )

        let client = makeClient()
        let result: SampleResponse = try await client.requestDecodable(url: sampleURL.absoluteString, method: .get)

        XCTAssertEqual(result.name, expected.name)
    }

    func testRequestDecodableMapsServerError() async {
        URLProtocolStub.responseData = Data()
        URLProtocolStub.response = HTTPURLResponse(
            url: sampleURL,
            statusCode: 500,
            httpVersion: nil,
            headerFields: nil
        )

        let client = makeClient()

        do {
            let _: SampleResponse = try await client.requestDecodable(url: sampleURL.absoluteString, method: .get)
            XCTFail("Expected to throw")
        } catch {
            guard case let AppError.server(code, _) = error as? AppError else {
                XCTFail("Unexpected error type: \(error)")
                return
            }
            XCTAssertEqual(code, 500)
        }
    }

    // MARK: - Helpers

    private let sampleURL = URL(string: "https://campick.shop/api/sample")!

    private func makeClient() -> VehicleAPIClient {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolStub.self]
        let session = Session(configuration: configuration)
        return VehicleAPIClient(session: session)
    }
}

// MARK: - Test Doubles

private struct SampleResponse: Codable, Equatable {
    let name: String
}

private final class URLProtocolStub: URLProtocol {
    static var response: HTTPURLResponse?
    static var responseData: Data?
    static var error: Error?

    override class func canInit(with request: URLRequest) -> Bool {
        true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        if let error = Self.error {
            client?.urlProtocol(self, didFailWithError: error)
            return
        }

        if let response = Self.response {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }

        if let data = Self.responseData {
            client?.urlProtocol(self, didLoad: data)
        }

        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}

    static func reset() {
        response = nil
        responseData = nil
        error = nil
    }
}
