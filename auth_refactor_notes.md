# Auth/User 영역 Clean Architecture + MVVM 전환 요약

## 목표
- ViewModel과 서비스에서 네트워크/토큰 로직을 걷어내고 Domain → Data → Presentation 계층을 명확히 분리.
- 테스트 가능하고 확장 가능한 Auth/User 흐름을 위한 UseCase · Repository 추상화 도입.

## 구조 변화
- `Domain/Auth`: `AuthSession`, `AuthRepository`, `LoginUseCase`, `LogoutUseCase` 등 핵심 엔티티와 유스케이스 추가.
- `Data/Auth`: `AuthRepositoryImpl`, `DefaultAuthRemoteDataSource`로 기존 `AuthAPI` 호출을 캡슐화하고 DTO→Domain 매핑을 수행.
- `Data/User`: `UserSessionRepositoryImpl`이 `TokenManager`와 `UserState`를 래핑하여 세션 저장/정리를 담당.
- `Application/DI`: `AuthDependencyContainer`를 통해 필요한 UseCase를 ViewModel·Service가 주입받도록 구성.

## Presentation 업데이트
- `LoginViewModel`, `SignupFlowViewModel`, `FindPasswordViewModel`, `HomeProfileViewModel`, `ProfileViewViewModel`, `ProfileScreenViewModel` 등에서 직접 `AuthAPI` 호출 제거.
- 비밀번호 변경 뷰(`PasswordChangeView`) 또한 유스케이스 기반으로 동작.

## 세션 저장 흐름
```
ViewModel → UseCase → AuthRepository → RemoteDataSource(AuthAPI)
                                 ↓
                       UserSessionRepository(TokenManager + UserState)
```

## 후속 계획
- Unit Test에서 UseCase를 독립적으로 검증할 수 있도록 Mock Repository 구성.
- 동일 패턴으로 차량 도메인(매물 조회/상세/상태 변경)을 차례로 리팩터링 예정.
