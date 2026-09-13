# Architecture Overview — FitBizz

## System High-Level Topology

```
+-------------------------------------------------------------+
|                     Client Layer                            |
|  +-------------------------------------------------------+  |
|  |                 Flutter Application                   |  |
|  |             (Android & Windows Desktop)               |  |
|  |  +-------------------+         +-------------------+  |  |
|  |  |  Presentation UI  |         |   Local Database  |  |  |
|  |  +---------+---------+         |   (Offline-First) |  |  |
|  |            |                   +---------+---------+  |  |
|  |            +---------+-------------------+            |  |
|  |                      |                                |  |
|  |            +---------v---------+                      |  |
|  |            | Domain Services   |                      |  |
|  |            +---------+---------+                      |  |
|  +----------------------|--------------------------------+  |
+-------------------------|-----------------------------------+
                          | HTTP / REST API
                          v
+-------------------------------------------------------------+
|                     Backend Layer                           |
|  +-------------------------------------------------------+  |
|  |               Java Spring Boot 3.x                    |  |
|  |  +-------------------+         +-------------------+  |  |
|  |  |  REST Controllers | ------> |  Service Layer    |  |  |
|  |  +-------------------+         +---------+---------+  |  |
|  |                                          |            |  |
|  |                                +---------v---------+  |  |
|  |                                |  JPA Repositories |  |  |
|  |                                +---------+---------+  |  |
|  +------------------------------------------|------------+  |
+---------------------------------------------|---------------+
                                              v
+-------------------------------------------------------------+
|                    Database Layer                           |
|               PostgreSQL Database Server                    |
+-------------------------------------------------------------+
```

## Modular Feature Structure

Client and backend code follow clean modular isolation:

```text
lib/features/
├── <feature_name>/
│   ├── presentation/   # UI screens, widgets, controllers/state
│   ├── domain/         # Entities, use-cases, value objects
│   └── data/           # Local DB data sources, mappers, API services
```

## Layered Component Summary

### 1. Flutter Application (`fitbizz_app/`)
* **Platform Strategy**: Single unified codebase for Android mobile and Windows Desktop x64.
* **UI & Presentation**: Responsive/adaptive widgets using centralized primitives (`AppButton`, `AppDataTable`, `AppCard`, etc.).
* **Local Database (Offline-First)**: Local persistent storage serving as primary data source for UI.
* **Resilient Sync Engine**: Background process handling offline transaction queue and Spring Boot REST API synchronization.

### 2. Spring Boot Backend (`fitbizz_backend/`)
* **Multi-Tier Architecture**:
  - **Controllers**: Thin HTTP request/response handlers with `@Valid` DTO parameters.
  - **Services**: Domain business rules and transaction management (`@Transactional`).
  - **Repositories**: JPA repositories interfacing with PostgreSQL.
* **Port**: `8080`, configurable via environment variables.

### 3. Server Database
* **Database**: PostgreSQL 17 server.
* **Integrity**: Explicit foreign keys, UUID primary keys, audit timestamps (`created_at`, `updated_at`), soft deletion (`is_deleted`), and versioned schema migrations.
