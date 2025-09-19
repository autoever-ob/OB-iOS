//
//  APILogger.swift
//  campick
//
//  Created by Assistant on 9/19/25.
//

import Foundation
import Alamofire

final class APILogger: EventMonitor {
    let queue = DispatchQueue(label: "campick.api.logger")

    func request(_ request: Request, didCreateURLRequest urlRequest: URLRequest) {
        let method = urlRequest.httpMethod ?? "-"
        let url = urlRequest.url?.absoluteString ?? "-"
        AppLog.logRequest(method: method, url: url, body: urlRequest.httpBody)
    }

    func requestDidResume(_ request: Request) {
        if let url = request.request?.url?.absoluteString, let method = request.request?.httpMethod {
            AppLog.debug("RESUME \(method) \(url)", category: "NET")
        }
    }

    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        let url = request.request?.url?.absoluteString ?? "-"
        let method = request.request?.httpMethod ?? "-"
        let code = response.response?.statusCode ?? -1
        switch response.result {
        case .success:
            AppLog.logResponse(status: code, method: method, url: url, data: response.data, error: nil)
        case .failure(let error):
            var msg = error.localizedDescription
            if let urlError = (error.underlyingError as NSError?) as NSError?, urlError.domain == NSURLErrorDomain {
                msg += " (URLError: \(urlError.code))"
            }
            AppLog.logResponse(status: code, method: method, url: url, data: response.data, error: msg)
        }
    }
}
