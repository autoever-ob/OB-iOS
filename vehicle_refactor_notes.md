# Vehicle 도메인 Clean Architecture + MVVM 리팩터링 정리

## 목표
- 차량 추천/목록/상세/등록 흐름에서 ViewModel이 네트워크 DTO와 직접 결합하는 구조를 제거.
- Domain ↔ Data ↔ Presentation 계층으로 분리해 비즈니스 규칙과 인프라 구현을 독립시킴.

## Domain 계층
- `Domain/Vehicle/VehicleModels.swift`: 목록/추천/상세/등록 초안 등을 표현하는 순수 모델(`VehicleSummaryDomainModel`, `VehicleDetailDomainModel`, `VehicleDraftDomainModel` 등) 정의.
- `VehicleRepository` 인터페이스와 `VehicleUseCases.swift` 에서 목록 조회, 추천, 상세, 좋아요 토글, 상태 변경, 등록/수정, 메타데이터 조회를 유스케이스로 캡슐화.

## Data 계층
- `Data/Vehicle/DataSources/VehicleRemoteDataSource`가 `ProductAPI` 호출을 래핑하여 DTO 통신만 담당.
- `VehicleDataMapper`가 DTO→Domain 매핑을 수행해 Presentation이 DTO 포맷을 알 필요가 없도록 구성.
- `VehicleRepositoryImpl`이 UseCase에서 요구하는 Domain 모델을 반환하고, 등록/수정/상태 변경 요청을 처리.

## Presentation 계층 변경
- `HomeVehicleViewModel`, `FindVehicleViewModel`, `VehicleDetailViewModel`, `VehicleRegistrationViewModel`, `VehicleCardViewModel`, `FavoritesViewModel`이 각각 UseCase를 주입받아 동작.
- ViewModel에서는 Domain 모델을 뷰 표현용 구조체(`VehicleDetailViewData`, `HomeVehicleViewModel.VehicleCardData`, 기존 `Vehicle`)로 변환하여 UI 연결.
- 추천/찜/검색 등에서 공통 포맷터를 ViewModel 내부로 통합, 문자열 가공 로직을 계층 경계에 맞게 재배치.

## DI
- `VehicleDependencyContainer`가 단일 `VehicleRepositoryImpl`을 공유하며 각 UseCase를 생성. ViewModel 기본 이니셜라이저에서 컨테이너를 사용해 의존성을 주입.

## 후속 과제
- 차량 등록/수정 흐름에 대한 단위 테스트와 Mock Repository 작성.
- Domain 모델 확장을 통해 Plate/Fuel 등 세부 필드 검증 로직을 UseCase 수준으로 끌어올릴 여지 검토.
- 레거시 `VehicleService`는 제거 완료, 추가로 `ProductAPI` 대체 전략을 검토.
