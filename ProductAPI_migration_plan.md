# ProductAPI 제거 및 DataSource 직접화 계획

현재 `ProductAPI`는 차량 도메인용 API 호출을 모두 몰아넣은 정적 유틸이며, `DefaultVehicleRemoteDataSource`가 이를 다시 래핑하고 있습니다. 향후 목표는 `VehicleRemoteDataSource`가 `APIService`를 직접 사용하도록 분해해, 정적 헬퍼를 완전히 제거하는 것입니다.

## 1. 사용 현황 정리
- **추천/좋아요 토글**: `fetchRecommendedVehicles`, `likeProduct`
- **목록/검색**: `fetchProducts`
- **상세/상태 변경**: `fetchProductDetail`, `updateProductStatus`
- **찜 목록**: `fetchFavorites`
- **등록/수정**: `createProduct`, `updateProduct`
- **메타데이터**: `fetchProductInfo`
- (Legacy) `ProductAPI` 파일 내에만 `APIService` 호출이 집중되어 있으며, 현재 호출자는 `DefaultVehicleRemoteDataSource`뿐임

## 2. 단계적 마이그레이션 전략
1. **공통 HTTP 유틸 추출** *(진행 중)*
   - `VehicleRemoteDataSource` 내부에서 사용할 전용 요청 빌더/응답 디코더 유틸(예: `VehicleAPIClient`)를 추가해 `APIService` 호출 패턴을 통일.
   - 에러 매핑(`ErrorMapper`)·응답 래퍼(`ApiResponse`)는 재사용.

2. **Read 계열(API GET)부터 이관**
   - Wave A ✅ : `fetchRecommendedVehicles`, `fetchProductInfo`
   - Wave B ✅ : `fetchProducts`, `fetchFavorites`
   - Wave C: `fetchProductDetail`
   각 웨이브마다 `VehicleRemoteDataSource`에서 직접 `APIService`를 사용하도록 수정하고, 동일 기능을 호출하는 UseCase에 대한 리그레션 테스트(간단한 smoke) 수행.

3. **Write 계열(PATCH/POST) 이관**
   - Wave D: `likeProduct`, `updateProductStatus`
   - Wave E: `createProduct`, `updateProduct`
   - 성공/실패 조건을 Domain Layer로 명확히 반환(예: 상태코드/메시지 전달)하고, ViewModel에서 공통 헬퍼(`handleResult`)를 활용.

4. **ProductAPI 단계적 폐기**
   - 모든 메서드 이관 후 `ProductAPI`에서 Deprecated 주석 추가 → 이후 삭제.
   - 남아 있는 참고 문서를 업데이트하고, `rg "ProductAPI"` 결과가 0이 되면 파일 제거.

## 3. 고려 사항
- **테스트**: 각 웨이브 완료 시 핵심 화면(Home, Find, Favorites, Detail, Registration) 수동 검증.
- **로그/에러 메시지**: 현재 `ProductAPI`에서 남기는 `AppLog` 출력은 `VehicleRemoteDataSource`로 옮겨 동일 레벨 유지.
- **공유 DTO/Request**: `VehicleRegistrationRequest`, `ProductFilterRequest` 등은 Data 계층에 이미 존재하므로 그대로 사용.
- **추후 확장**: Auth와 동일하게 향후 다른 도메인(Product 외 Category 등)도 동일 패턴으로 확장할 수 있도록 `Application/DI`에 컨테이너 패턴 유지.

## 4. 완료 기준
- `VehicleRemoteDataSource`가 모든 네트워크 호출을 직접 수행
- `ProductAPI.swift` 삭제
- 관련 문서(`vehicle_refactor_notes.md`, `refactor_background.md`)에서 `ProductAPI` 언급 제거
