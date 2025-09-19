import Foundation

// 서버의 /api/product 응답 중 개별 매물 아이템을 표현하는 DTO
// 주의: 서버 키 이름과 정확히 일치시키기 위해 CodingKeys 불필요 (동일 케이스)
struct ProductItemDTO: Decodable {
    // 현재 로그인 사용자가 좋아요한 상태인지 여부
    let isLiked: Bool
    // 해당 매물의 좋아요 개수
    let likeCount: Int
    // 매물 제목 (예: "현대 아반떼 2021 1.6 가솔린")
    let title: String
    // 가격 표시 문자열 (예: "1,150만 원")
    let price: String
    // 주행거리 표시 문자열 (예: "42,000 km")
    let mileage: String
    // 지역/위치 (예: "서울 강남구")
    let location: String
    // 생성 일시(ISO-8601 문자열)
    let createdAt: String
    // 썸네일 이미지 절대 URL 문자열
    let thumbNail: String
    // 매물 고유 ID
    let productId: Int
    // 상태 값: "AVAILABLE" | "RESERVED" | "SOLD"
    let status: String
}
