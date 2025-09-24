# campick 모델 계층 개요

## MVVM 개요
- campick 앱은 `Model-View-ViewModel` 구조를 따르며, 화면 로직(View)과 비즈니스 상태(ViewModel), 데이터 표현(Model)을 명확히 분리해 테스트 가능성과 재사용성을 높였습니다.
- View는 SwiftUI 기반으로 사용자 인터랙션과 레이아웃만 담당하고, 네트워크·저장소 접근은 ViewModel을 통해 간접적으로 수행됩니다.

## MVVM에서의 책임 분리
- **Model**: 애플리케이션의 도메인 데이터와 비즈니스 규칙을 표현하며, 영속성과 네트워크 계층을 추상화해 UI와 독립적으로 유지됩니다.
- **ViewModel**: Model과 View 사이의 매개체로서 상태를 가공해 노출하고, 사용자 입력을 비즈니스 동작으로 변환하며, 플랫폼·UI 세부 사항과 도메인 로직을 분리합니다.
- **View**: ViewModel이 제공하는 상태를 관찰해 UI를 렌더링하고 입력 이벤트를 전달하며, 화면 구성과 표현 로직에만 집중하고 비즈니스 규칙을 포함하지 않습니다.

## 전체 구조 요약
- `Models` 폴더는 기능 단위 하위 디렉터리(Auth, Chat, Product 등)에 DTO·요청 객체·응답 래퍼를 배치해 모듈화를 유지합니다.
- 공통으로 활용되는 제너릭 페이지네이션과 차량 분류 정의는 `Models/Common`에 모아 두어 재사용성을 높입니다.
- 사용자 세션, 지역 데이터처럼 전역 범위에서 활용되는 모델은 최상위 파일(`UserState`, `KoreanDistricts`)로 분리하여 어디서든 주입 없이 접근할 수 있습니다.
- 차량 도메인 모델(`Vehicle`, `RecommendedVehicle`, `VehicleResponse`)은 뷰 바인딩에 필요한 표현 값을 함께 노출하여 ViewModel 단에서의 후처리를 최소화합니다.
- Auth 계층의 디코딩 유틸리티(`decodeFlexibleString`)는 서버 타입 변동에 대응하며 다른 도메인 모델에서도 재사용됩니다.

```text
Models/
├── Auth/
│   ├── ApiResponse.swift
│   ├── AuthResponse.swift
│   ├── UserDTO.swift
│   ├── DecodingExtensions.swift
│   └── ... 로그인·회원가입 요청 DTO
├── Category/
│   └── CategoryModels.swift
├── Chat/
│   ├── Chat.swift
│   ├── ChatList.swift
│   ├── ChatResponse.swift
│   └── ... 채팅 요청/응답 래퍼
├── Common/
│   ├── Page.swift
│   └── VehicleType.swift
├── Product/
│   ├── ProductItemDTO.swift
│   ├── ProductDetailDTO.swift
│   ├── ProductCreateRequest.swift
│   ├── ProductUpdateRequest.swift
│   └── ... 옵션/등록 관련 모델
├── Profile/
│   └── ProfileProductModels.swift
├── UserProfile.swift
├── UserState.swift
├── Vehicle.swift / VehicleResponse.swift / RecommendedVehicle.swift
└── KoreanDistricts.swift, UserType.swift 등
```

## 폴더별 세부 설명
### Auth
- `AuthResponse`가 토큰, 사용자 DTO, 프로필 정보를 하나로 묶어 반환하며 숫자/문자 혼합 필드를 `decodeFlexibleString`으로 정규화합니다.
- 로그인/회원가입/이메일 인증 요청 구조체는 모두 `Encodable`로 정의되어 서비스 레이어에서 바로 직렬화할 수 있습니다.
- `ApiResponse<T>` 제너릭 래퍼는 다른 도메인에서도 공통 응답 형태로 활용됩니다.

### Product
- `ProductItemDTO`, `ProductDetailDTO`는 서버 응답의 타입 변형(정수 ↔ 문자열, 배열 ↔ 단일 값)을 자체 디코딩 로직으로 해결하여 상위 계층에 정제된 데이터를 제공합니다.
- 등록·수정 요청(`ProductCreateRequest`, `ProductUpdateRequest`)은 위치 및 옵션 페이로드를 별도 구조체로 분리해 폼 데이터를 명확히 표현합니다.
- `VehicleRegistrationRequest`는 등록 화면 전용 전송 모델로, 실제 뷰 표현 모델(`Vehicle`)과 역할을 구분합니다.

### Chat
- `ChatList`, `Chat`, `ChatResponse` 등 목록·대화·응답 모델이 분리되어 있으며 `ChatListResponse`는 전체 미확인 메시지 수까지 포함합니다.
- `ChatStartRequest` 등 요청 모델을 함께 보관하여 ViewModel에서 바로 API 계층으로 전달할 수 있습니다.

### Profile & Common
- `ProfileProductModels`는 `Page<ProfileProduct>` 조합으로 프로필 화면의 페이징을 구성하며, 생성일 파싱과 비용 포맷을 자체 처리합니다.
- 공통 페이지네이션 구조체 `Page<T>`, `PageSort`, `Pageable`은 다양한 목록 API에서 재사용되며 `page`와 `number` 키를 모두 지원합니다.
- `VehicleType`은 화면 표시명, API 전달값, 이미지 에셋 키를 함께 제공하여 분기 로직을 단순화합니다.

### 전역 모델
- `UserState`는 `ObservableObject` 싱글턴으로 사용자 로그인 상태와 기본 정보를 보관하고 `UserDefaults` 및 토큰 관리자를 래핑합니다.
- `UserProfile.swift`는 최신 API 응답(`ProfileData`)과 과거 모델(`UserProfile`)을 동시에 유지하여 하위 호환성을 제공합니다.
- `KoreanDistricts`는 지역 필터·입력 UI에서 사용하는 정적 데이터를 중앙집중화합니다.

## 데이터 흐름 및 사용 패턴
- 서비스 계층이 API 호출 후 `ApiResponse<T>` → 개별 DTO → ViewModel 순으로 데이터를 전달하며, ViewModel은 즉시 UI에 바인딩하거나 `UserState` 갱신을 수행합니다.
- 다형적 타입(문자열/숫자 혼재)과 다중 날짜 포맷 처리는 모델 내부에서 해결되어 상위 계층에선 일관된 문자열·숫자·`Date` 값을 받을 수 있습니다.
- ENUM(`VehicleStatus`, `UserType`)은 UI 표시 문자열과 색상/아이콘과 같은 표현 속성을 함께 포함해 뷰 코드의 조건문을 줄입니다.

## 유지보수 체크리스트
- 새로운 API를 추가할 때는 관련 DTO·요청 객체를 기능별 하위 폴더에 배치하고, 공통으로 쓰일 디코딩 로직은 `Common` 혹은 `Auth/DecodingExtensions`에 확장하세요.
- 페이징 응답 구조가 변경될 경우 `Page<T>`의 `CodingKeys`를 업데이트해 `page`/`number` 키 호환성을 유지하세요.
- `UserState` 수정 시 스레드 안전성과 `UserDefaultsManager` 키 누락 여부를 점검하고, 필요하다면 Combine 기반 구독이 적절히 갱신되는지 확인하세요.
- 정적 데이터(예: `KoreanDistricts`)가 변경될 때는 UI와 필터 옵션 업데이트를 동시에 검토하세요.

## 참고 파일 경로
- 핵심 모델 정의: `Models/Vehicle.swift`, `Models/Product/ProductDetailDTO.swift`, `Models/Auth/AuthResponse.swift`
- 공통 유틸리티: `Models/Common/Page.swift`, `Models/Auth/DecodingExtensions.swift`
- 전역 상태 및 정적 데이터: `Models/UserState.swift`, `Models/KoreanDistricts.swift`

## USER 관련 MVVM 점검
### 현재 동작 흐름
- 로그인은 `LoginViewModel`이 `AuthAPI.login`을 호출해 토큰을 `TokenManager`에 저장하고 `UserState`를 갱신하며, `RootView`가 `UserState.isLoggedIn` 변화를 감지해 화면을 전환합니다.
- 프로필 화면은 `ProfileScreenViewModel`→`ProfileDataViewModel`→`ProfileService` 순으로 데이터를 불러오고, `UserState`를 통해 현재 사용자 식별자를 가져옵니다.
- 전역 싱글턴 `UserState`는 로그인 상태, 프로필 요약, 연락처 등 사용자 정보를 저장·배포하는 사실상의 세션 레이어입니다.

### 확인된 문제
- View가 직접 세션 상태와 네트워크 호출을 다루어 MVVM 경계를 침범합니다. 예) `LoginView`가 `UserState.shared`를 `@StateObject`로 보관하고(`Views/Auth/Login/LoginView.swift:13`), `ProfileEditModal`이 프로필 수정 API와 `UserState` 업데이트를 직접 수행합니다(`Views/Components/Profile/ProfileEditModal.swift:29`, `Views/Components/Profile/ProfileEditModal.swift:225`, `Views/Components/Profile/ProfileEditModal.swift:260`).
- 사용자 메뉴 UI 역시 뷰 내부에서 `UserState`와 네비게이션 로직을 혼재해 재사용성과 테스트가 떨어집니다(`Views/Components/Home/ProfileMenu.swift:14`, `Views/Components/Home/ProfileMenu.swift:118`, `Views/Components/Home/ProfileMenu.swift:155`).
- 프로필용 ViewModel이 이중화돼 있습니다. `ProfileScreenViewModel`과 별개로 `ProfileViewViewModel`이 더미 데이터를 생성하고 `UserState`에 직접 접근하는데(`ViewModels/ProfileViewViewModel.swift:44`), 일부 컴포넌트는 여전히 이 타입에 의존합니다(`Views/Components/Profile/TabNavigationCompact.swift:9`).
- 데이터 레이어 접근 시 `UserState`에 암묵적으로 의존해 테스트와 재사용이 어렵습니다(`ViewModels/ProfileDataViewModel.swift:47`, `ViewModels/ProfileDataViewModel.swift:114`, `ViewModels/ProfileDataViewModel.swift:138`).
- 인증 서비스가 중복 구현되었습니다. `HomeProfileViewModel` 등이 `AuthAPI`를 직접 호출해 로그아웃을 처리하고 있어 `AuthService`·`UserState`와 책임이 중첩됩니다(`ViewModels/HomeProfileViewModel.swift:8`).

### 정리 및 제안
- 뷰에는 `UserState`를 `@EnvironmentObject`로 주입하거나, ViewModel이 노출하는 View 전용 상태만 구독하도록 수정해 View ↔ ViewModel 경계를 명확히 하세요.
- 프로필 편집, 로그아웃 등 사용자 행동은 전담 ViewModel에 위임하고, View는 액션 트리거만 담당하도록 분리해 테스트 포인트를 줄입니다.
- DTO는 `Data/DTOs/Auth`, `Data/DTOs/Profile`처럼 네트워크 전용 계층으로 분리하고, 도메인 모델은 `Data/Auth/Models` 또는 `Domain/Auth/Models`에 두어 Model 디렉터리가 순수 도메인 역할만 하도록 리팩터링하세요.
- `ProfileViewViewModel` 같은 임시 구현을 제거하거나 최신 데이터 파이프라인(`ProfileScreenViewModel`)으로 통합해 중복 코드를 정리합니다.
- 데이터 로더가 필요한 ID를 의존성으로 주입받도록 바꾸고, `UserState` 접근은 상위 계층에서 한 번만 수행하세요.
- 인증·프로필과 같은 사용자 흐름에는 `UserRepository`, `ProfileRepository`를 둬서 `AuthService`/`ProfileService`(네트워크)와 `UserState`(세션)의 중재자 역할을 맡기고, ViewModel은 Repository 인터페이스만 의존하도록 구성하세요. 이렇게 하면 토큰 관리·캐시·오프라인 처리 확장성이 높아집니다.

