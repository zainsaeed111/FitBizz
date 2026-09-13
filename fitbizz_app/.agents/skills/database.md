# Skill: Database & Synchronization (`PostgreSQL & Local Storage`)

## Core Practices

### 1. Database Schema Standards
* **Primary Keys**: UUIDs (`UUID` / `String`) preferred for multi-tenant and offline sync safety across distributed client nodes.
* **Audit Timestamps**: Every table/entity must include `created_at` (Timestamp) and `updated_at` (Timestamp).
* **Soft Deletion**: Use `is_deleted` (Boolean) flag for auditability and sync tombstones.
* **Indexing**: Index foreign keys, tenant IDs, sync version columns, and frequently queried lookup fields.

### 2. Local Client Database (Offline-First)
* Local storage serves as the immediate source of truth for the Flutter client app.
* User actions persist locally first; sync operations occur asynchronously in the background.
* Offline change tracking: Local entities maintain sync state flags (e.g., `sync_status`: `PENDING`, `SYNCED`, `CONFLICT`).

### 3. Online Synchronization & Conflict Handling
* **Data Integrity First**: Local database state must never be destroyed or wiped due to network errors or HTTP request failures.
* **Sync Strategy**: Incremental timestamp/version-based synchronization.
* **Conflict Resolution**: Server timestamp wins by default, with client resolution hooks for user-entered conflicting edits.
* Do not prematurely build overly complex sync engines; implement clean, predictable incremental syncing as features are added.
