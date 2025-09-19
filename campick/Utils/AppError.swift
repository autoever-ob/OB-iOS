//
//  AppError.swift
//  campick
//
//  Created by Assistant on 9/19/25.
//

import Foundation
import Alamofire

enum AppError: Error, LocalizedError {
    case network(String)
    case timeout
    case cannotConnect
    case hostNotFound
    case cancelled
    case unauthorized
    case forbidden
    case notFound
    case conflict
    case tooManyRequests
    case server(Int, String?)
    case decoding
    case unknown(String)

    var errorDescription: String? { message }

    var message: String {
        switch self {
        case .network(let msg): return msg.isEmpty ? "네트워크 연결에 문제가 발생했습니다." : msg
        case .timeout: return "요청이 시간 초과되었습니다. 네트워크 상태를 확인해주세요."
        case .cannotConnect: return "서버에 연결할 수 없습니다. 네트워크 또는 서버 상태를 확인해주세요."
        case .hostNotFound: return "서버 주소를 찾을 수 없습니다. 도메인 설정을 확인해주세요."
        case .cancelled: return "요청이 취소되었습니다."
        case .unauthorized: return "인증이 필요합니다. 다시 로그인해주세요."
        case .forbidden: return "접근 권한이 없습니다."
        case .notFound: return "요청한 리소스를 찾을 수 없습니다."
        case .conflict: return "요청이 충돌했습니다. 입력값을 확인해주세요."
        case .tooManyRequests: return "요청이 너무 많습니다. 잠시 후 다시 시도해주세요."
        case .server(_, let msg): return msg ?? "서버 오류가 발생했습니다. 잠시 후 다시 시도해주세요."
        case .decoding: return "응답 처리 중 오류가 발생했습니다."
        case .unknown(let msg): return msg
        }
    }
}

enum ErrorMapper {
    static func map(_ error: Error) -> AppError {
        if let app = error as? AppError { return app }

        if let urlErr = error as? URLError {
            switch urlErr.code {
            case .timedOut: return .timeout
            case .cannotConnectToHost: return .cannotConnect
            case .cannotFindHost: return .hostNotFound
            case .notConnectedToInternet, .networkConnectionLost, .dnsLookupFailed: return .network(urlErr.localizedDescription)
            case .cancelled: return .cancelled
            default: return .network(urlErr.localizedDescription)
            }
        }

        if let afErr = error as? AFError {
            switch afErr {
            case .responseValidationFailed(let reason):
                switch reason {
                case .unacceptableStatusCode(let code):
                    switch code {
                    case 401: return .unauthorized
                    case 403: return .forbidden
                    case 404: return .notFound
                    case 409: return .conflict
                    case 429: return .tooManyRequests
                    default: return .server(code, nil)
                    }
                default:
                    break
                }
            case .responseSerializationFailed:
                return .decoding
            case .sessionTaskFailed(let underlying as URLError):
                return map(underlying)
            default:
                break
            }
        }

        return .unknown(error.localizedDescription)
    }
}
