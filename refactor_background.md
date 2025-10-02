# 클린 아키텍처 + MVVM 도입 배경

## 현재 드러난 문제 인식
- ViewModel이 네트워크 계층과 직접 결합돼 있어 관심사 분리가 지켜지지 않고 있음. 예를 들어 `campick/ViewModels/VehicleDetailViewModel.swift:11`에서는 ViewModel이 `ProductAPI`를 직접 호출하며 에러 매핑과 도메인 상태 관리까지 떠안고 있다.
- DTO → 화면 표시 값 가공 로직이 ViewModel 내부(`VehicleDetailViewData`, `DetailFormatter`)에 뒤섞여 있어 재사용이 어렵고, 동일 포맷터가 다른 화면에 필요할 때 중복 구현이 발생하고 있다.
- Repository 추상화가 없고, 서비스/매니저가 전역으로 호출되면서 도메인 규칙을 중앙에서 다루지 못해 기능이 늘어날수록 ViewModel이 비즈니스 규칙과 UI 상태를 동시에 처리하는 Massive ViewModel 패턴으로 흐르고 있다.
- 테스트 관점에서 네트워크/스토리지 의존성이 직접 박혀 있어 단위 테스트를 작성하기 어렵고, 빠른 회귀 검증 체계를 갖추기 힘들다. 현재 구조로는 API 스텁 없이 ViewModel 테스트를 실행하기 어렵다.

## 전환을 통해 해결하려는 목표
- Domain Layer에 엔티티·UseCase·Repository 인터페이스를 둬 핵심 정책을 UI나 외부 인프라 변화와 분리하고 변경 파급 범위를 최소화한다.
- Data Layer는 Repository 구현, API 클라이언트, 로컬 캐시를 담당하고, Presentation Layer는 View/ViewModel이 순수 상태 관리와 바인딩에만 집중하도록 역할을 재정의한다.
- ViewModel은 UseCase를 통해 데이터 접근을 요청하고, UseCase는 필요한 Repository를 의존성 주입으로 받아 사용함으로써 테스트와 모듈 교체가 수월해진다.
- DTO → Domain → ViewData 변환을 계층별로 분리해 재사용 가능한 매퍼/포맷터를 확보하고, 중복 로직을 줄인다.

### 현재 구조 vs 목표 구조 도식화

```text
현재 (MVVM 내부 결합)
View ↔ ViewModel ──▶ ProductAPI/Service ──▶ Network/DB
            ▲            (ViewModel이 통신·매핑·에러 처리까지 담당)

목표 (Clean Architecture + MVVM)
View ↔ ViewModel ──▶ UseCase ──▶ Repository Interface ──▶ Repository Impl ──▶ Remote/Local DataSource
            ▲                    (Domain)                  (Data Layer)

주요 변화
- ViewModel은 UseCase만 호출하며, 통신 규약·포맷 변환을 몰라도 된다.
- UseCase는 비즈니스 규칙을 중심으로 Repository 인터페이스에만 의존한다.
- Repository 구현이 Remote/Local DataSource를 조합해 Domain 계층을 보호한다.
- DTO ↔ Domain ↔ ViewData 변환이 계층별로 분리돼 테스트와 확장성이 향상된다.
```

### 모델의 종류와 참조 주체

```text
Data Layer: DTO (예: ProductDetailDTO)
- Remote/Local DataSource가 API 응답을 그대로 담는 전송 모델.
- Repository Impl만 DTO를 알고 있으며 Domain으로 매핑해 전달한다.

Domain Layer: Entity/ValueObject (예: Vehicle)
- UseCase와 Repository Interface가 사용하는 순수 비즈니스 모델.
- Presentation이나 Data Source가 직접 참조하지 않는다.

Presentation Layer: ViewData/ViewState (예: VehicleDetailViewData)
- ViewModel이 Domain 모델을 화면 표현용으로 변환한 결과.
- View와 ViewModel만 참조하며 다른 레이어로 역참조되지 않는다.
```

## 기대 효과
- 관심사 분리로 ViewModel 복잡도가 줄어들고, 새 화면 추가 시 공통 정책을 재사용할 수 있다.
- UseCase 단위 테스트가 가능해져 핵심 로직을 빠르게 검증하고, API 실패 시나리오를 안정적으로 다룰 수 있다.
- Repository 인터페이스를 통해 네트워크·스토리지 구현을 교체하거나 오프라인 모드를 도입할 때 Domain Layer 변경 없이 대응할 수 있다.
- 모듈 단위 분리가 가능해져 향후 팀 단위 개발/배포 파이프라인을 개선하고, 의존성 그래프가 명확해진다.

## 향후 리팩터링 방향
1. 기능별로 우선순위를 정해 각 ViewModel이 담당하던 비즈니스 로직을 UseCase로 분리하고, 테스트 케이스부터 작성한다.
2. Domain 레이어(Entity, ValueObject, UseCase, Repository Interface)를 새 디렉터리 구조와 함께 정의하고, Data 레이어에 기존 Services/Managers를 Repository 구현으로 재배치한다.
3. DTO ↔ Domain ↔ ViewData 변환 책임을 별도의 매퍼로 분리하고, 공통 포맷터를 유틸이 아닌 Domain/Presentation 경계에 맞춰 재조정한다.
4. DI 컨테이너를 정비해 ViewModel 생성 시 필요한 UseCase/Repository가 명시적으로 주입되도록 바꾼다.
5. 전환이 완료된 기능부터 문서화와 코드 예시를 남겨 팀이 동일한 패턴으로 확장하도록 안내한다.

## USER & AUTH 리팩터링 현황
- Domain/Auth 에 `AuthSession`, `AuthRepository`, `LoginUseCase` 등 핵심 엔티티와 유스케이스를 정의해 Presentation에서 직접 네트워크/토큰 로직을 제거했다.
- Data/Auth 는 `AuthRepositoryImpl`과 `DefaultAuthRemoteDataSource`로 구성되어 기존 `AuthAPI` 호출을 캡슐화하고, 응답 DTO를 Domain 모델로 매핑한다.
- User 세션은 `UserSessionRepositoryImpl`이 `TokenManager`와 `UserState`를 감싸도록 분리해 Domain에서 세션 저장/삭제를 호출할 수 있게 했다.
- `AuthDependencyContainer`를 통해 ViewModel/Service에서 필요한 UseCase를 주입하며, `LoginViewModel`, `SignupFlowViewModel`, `FindPasswordViewModel`, 프로필 관련 ViewModel/뷰들이 모두 UseCase를 사용하도록 정리했다.

## Vehicle 도메인 리팩터링 현황
- Domain/Vehicle에 추천·목록·상세·등록 모델과 `VehicleRepository`, 각종 UseCase를 정의해 UI에서 DTO 처리·비즈니스 로직을 분리했다.
- Data/Vehicle은 `DefaultVehicleRemoteDataSource`와 `VehicleRepositoryImpl`이 `ProductAPI`와 상호 작용하며 DTO ↔ Domain 매핑을 담당한다.
- `VehicleDependencyContainer`가 UseCase를 주입하고, `HomeVehicleViewModel`, `FindVehicleViewModel`, `VehicleDetailViewModel`, `VehicleRegistrationViewModel`, `FavoritesViewModel`, `VehicleCardViewModel`이 모두 UseCase 기반으로 동작한다.
- ViewModel은 Domain 모델을 화면 표현용 데이터로 변환하면서 포맷팅/이미지 프리로드 등 UI 로직만 유지한다.

이번 리팩터링은 단순한 패턴 변경이 아니라, 변화에 강하고 테스트 가능한 구조를 갖추기 위한 중장기 투자다. Clean Architecture + MVVM으로 레이어 경계를 명확히 하면 도메인 정책을 안정적으로 유지하면서도 기능 확장과 유지보수 속도를 높일 수 있다.
