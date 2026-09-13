# Skill: Testing & Verification Strategy

## Core Principles
* **Meaningful Coverage**: Write tests that validate real business rules, API contracts, edge cases, and regressions. Do not write dummy tests solely for coverage stats.
* **Continuous Verification**: Execute analyzer and build commands after any code modification.

## 1. Flutter Client Testing (`fitbizz_app`)
* **Unit Tests**: Test business logic, utility classes, data mappers, and state transition logic (`test/` directory).
* **Widget Tests**: Validate key responsive UI components, button interaction states, and error message displays.
* **Static Analysis**: `flutter analyze` must return `No issues found!`.
* **Platform Build Verification**:
  - Windows: `flutter build windows`
  - Android: `flutter build apk`

## 2. Spring Boot Backend Testing (`fitbizz_backend`)
* **Unit & Service Tests**: Test core domain service methods using JUnit 5 and Mockito (`@ExtendWith(MockitoExtension.class)`).
* **API / Controller Tests**: Test REST endpoints using `@WebMvcTest` or `TestRestTemplate` to verify HTTP status codes and DTO JSON serialization.
* **Maven Build & Test Execution**:
  - `.\mvnw test`
  - `.\mvnw clean package`
