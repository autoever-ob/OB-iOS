//
//  AuthAPI.swift
//  campick
//
//  Created by Assistant on 9/19/25.
//

import Foundation
import Alamofire

enum AuthAPI {
    static func login(email: String, password: String) async throws -> AuthResponse {
        do {
            let req = LoginRequest(email: email, password: password)
            let request = APIService.shared
                .request(Endpoint.login.url, method: .post, parameters: req, encoder: JSONParameterEncoder.default)
                .validate()
            return try await request.serializingDecodable(AuthResponse.self).value
        } catch {
            throw ErrorMapper.map(error)
        }
    }

    static func signup(
        email: String,
        password: String,
        checkedPassword: String,
        nickname: String,
        mobileNumber: String,
        role: String,
        dealershipName: String,
        dealershipRegistrationNumber: String
    ) async throws -> AuthResponse {
        do {
            let body = SignupRequest(
                email: email,
                password: password,
                checkedPassword: checkedPassword,
                nickname: nickname,
                mobileNumber: mobileNumber,
                role: role,
                dealershipName: dealershipName,
                dealershipRegistrationNumber: dealershipRegistrationNumber
            )
            let request = APIService.shared
                .request(Endpoint.signup.url, method: .post, parameters: body, encoder: JSONParameterEncoder.default)
                .validate()
            return try await request.serializingDecodable(AuthResponse.self).value
        } catch {
            throw ErrorMapper.map(error)
        }
    }

    // 일부 서버가 본문 없이 200만 반환하는 경우 대응용
    static func signupAllowingEmpty(
        email: String,
        password: String,
        checkedPassword: String,
        nickname: String,
        mobileNumber: String,
        role: String,
        dealershipName: String,
        dealershipRegistrationNumber: String
    ) async throws -> AuthResponse? {
        let body = SignupRequest(
            email: email,
            password: password,
            checkedPassword: checkedPassword,
            nickname: nickname,
            mobileNumber: mobileNumber,
            role: role,
            dealershipName: dealershipName,
            dealershipRegistrationNumber: dealershipRegistrationNumber
        )
        do {
            let request = APIService.shared
                .request(Endpoint.signup.url, method: .post, parameters: body, encoder: JSONParameterEncoder.default)
                .validate()
            // 우선 성공 여부만 확인
            let data = try await request.serializingData().value
            // 본문이 있으면 디코딩 시도
            if !data.isEmpty {
                if let decoded = try? JSONDecoder().decode(AuthResponse.self, from: data) {
                    return decoded
                }
            }
            return nil
        } catch {
            throw ErrorMapper.map(error)
        }
    }

    static func sendEmailCode(email: String) async throws {
        do {
            let body = EmailSendRequest(email: email)
            let request = APIService.shared
                .request(Endpoint.emailSend.url, method: .post, parameters: body, encoder: JSONParameterEncoder.default)
                .validate()
            _ = try await request.serializingData().value
        } catch {
            throw ErrorMapper.map(error)
        }
    }

    static func confirmEmailCode(code: String) async throws {
        do {
            let body = EmailVerifyCodeRequest(code: code)
            let request = APIService.shared
                .request(Endpoint.emailVerify.url, method: .post, parameters: body, encoder: JSONParameterEncoder.default)
                .validate()
            _ = try await request.serializingData().value
        } catch {
            throw ErrorMapper.map(error)
        }
    }
}
