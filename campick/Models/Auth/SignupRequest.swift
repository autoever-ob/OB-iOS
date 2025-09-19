import Foundation

struct SignupRequest: Encodable {
    let email: String
    let password: String
    let checkedPassword: String
    let nickname: String
    let mobileNumber: String
    let role: String
    let dealershipName: String
    let dealershipRegistrationNumber: String
}

