# 03 — Architecture & Data Integrity Principles

1. **Feature Isolation & Modular Structure**:
   - Organize code by modular feature boundaries:
     ```text
     feature_name/
     ├── presentation/   (UI screens, widgets, controllers/state)
     ├── domain/         (Entities, business use-cases, value objects)
     └── data/           (Mappers, local DB storage, remote API services)
     ```
   - Features must have minimal coupling with other features. Extract shared logic only when genuinely reusable across multiple domain modules.

2. **Spring Boot Multi-Tier Architecture**:
   - **Controller**: Thin HTTP entry points with `@Valid` DTO parameters.
   - **Service**: Domain business logic, transaction boundaries (`@Transactional`), and multi-repository orchestration.
   - **Repository**: Spring Data JPA interfaces for PostgreSQL access.
   - **DTO**: Strict request/response representations at API boundaries. Database entities are never exposed to HTTP clients.

3. **Backend-First Data Integrity**:
   - Every meaningful feature must complete the end-to-end flow:
     `Flutter UI ↔ API DTO ↔ Spring Boot Service ↔ JPA Repository ↔ PostgreSQL Database`
   - Never build fake, frontend-only mocks when backend persistence is required.
   - When API contracts or DB schemas change, update all affected layers simultaneously: Backend Service -> DTOs -> `docs/API_CONTRACT.md` -> Client Service -> Database Migrations -> Automated Tests.

4. **Offline-First & Database Safety**:
   - **Local Storage as Primary**: Client UI reads from and writes to the local database. Core daily gym operations must remain 100% functional without internet connectivity.
   - **Resilient Sync Engine**: Synchronization runs as an isolated background task. Network failures or API HTTP errors must never erase or corrupt pending local user edits.
   - **Deliberate DB Migrations**: Never delete, rename, or modify database columns/tables casually. Always inspect dependencies, write explicit versioned migrations, and verify rollback paths.
