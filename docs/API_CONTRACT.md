# API Contract Specification — FitBizz

This document serves as the canonical contract between the Spring Boot backend (`fitbizz_backend`) and client applications (`fitbizz_app`).

## Guidelines
* **Strict Synchronization**: Never update backend endpoints or client HTTP calls without updating this contract document.
* **No Speculative Endpoints**: Only document endpoints that are actively implemented and tested in the codebase.
* **Data Transfer Objects**: All APIs use JSON requests and responses with explicit DTO structures.

---

## Active Endpoints

### 1. Authentication Login
```http
POST /api/v1/auth/login
Content-Type: application/json

Request Body:
{
  "email": "reception@fitbizz.com",
  "password": "Password123!",
  "tenantCode": "tenant-001"
}

Response (200 OK):
{
  "token": "eyJhbGciOiJIUzI1NiJ9...",
  "userId": "usr_123456",
  "tenantId": "tenant-001",
  "branchId": "branch-001",
  "role": "RECEPTIONIST",
  "fullName": "Demo Admin",
  "email": "reception@fitbizz.com"
}
```

### 2. Member Directory List & Create
```http
GET /api/v1/members
Authorization: Bearer <token>

Response (200 OK):
[
  {
    "id": "mem_001",
    "tenantId": "tenant-001",
    "branchId": "branch-001",
    "memberNumber": "MEM-1001",
    "fullName": "John Doe",
    "email": "john@example.com",
    "phone": "+1234567890",
    "status": "ACTIVE"
  }
]

POST /api/v1/members
Authorization: Bearer <token>
Content-Type: application/json

Request Body:
{
  "memberNumber": "MEM-1002",
  "fullName": "Jane Smith",
  "email": "jane@example.com",
  "phone": "+1987654321",
  "status": "ACTIVE"
}
```

### 3. Attendance Check-in Terminal
```http
POST /api/v1/attendance/checkin
Authorization: Bearer <token>
Content-Type: application/json

Request Body:
{
  "memberId": "mem_001",
  "method": "BARCODE"
}

Response (200 OK):
{
  "id": "att_001",
  "tenantId": "tenant-001",
  "branchId": "branch-001",
  "memberId": "mem_001",
  "checkInAt": "2026-09-13T00:43:00Z",
  "method": "BARCODE",
  "synced": true
}
```

### 4. Offline Synchronization Engine
```http
POST /api/v1/sync/push
Authorization: Bearer <token>
Content-Type: application/json

Request Body:
[
  {
    "operation": "CREATE_ATTENDANCE",
    "payload": { "memberId": "mem_001", "checkInAt": "2026-09-13T00:43:00Z" }
  }
]

GET /api/v1/sync/pull?sinceTimestamp=1750000000000
Authorization: Bearer <token>
```
