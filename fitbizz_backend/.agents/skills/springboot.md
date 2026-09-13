# Skill: Spring Boot Backend Development (`fitbizz_backend`)

## Core Practices

### 1. Architecture & Layering Rules
* **Controllers**:
  - Thin HTTP handlers annotated with `@RestController` and `@RequestMapping("/api/v1/...")`.
  - Validate input with `@Valid`. Pass clean DTOs to service methods.
  - Return explicit `ResponseEntity<DTO>` types with HTTP status codes (`200 OK`, `201 Created`, `400 Bad Request`, `404 Not Found`, etc.).
  - **NO business logic or direct database queries in controllers**.
* **Services**:
  - Class annotated with `@Service`. Wrap mutating methods with `@Transactional`.
  - Contains domain validation, business rules, entity mapping, and repository orchestration.
* **Repositories**:
  - Interfaces extending `JpaRepository<Entity, ID>`. Keep custom `@Query` definitions performance-optimized with indexed lookup columns.
* **DTOs**:
  - Java records or immutable POJOs for request payloads and response representations.
  - Entity objects must never be returned across controller API boundaries.

### 2. Configuration & Secrets
* Externalize configuration in `application.yml`.
* **Zero Hardcoded Secrets**: Use environment variable interpolation with fallback defaults (e.g., `${DB_PASSWORD:postgres}`).

### 3. Exception Handling & Logging
* Centralized exception handling using `@RestControllerAdvice` returning standardized error response payloads (`timestamp`, `status`, `error`, `message`, `path`).
* SLF4J/Logback structured logging (`log.info(...)`, `log.error(...)`). Avoid `System.out.println`.

### 4. Build & Verification Workflow
* **Maven Build**: `.\mvnw clean package` must complete with `BUILD SUCCESS`.
* **Tests**: `.\mvnw test` must pass all unit and integration test cases.
