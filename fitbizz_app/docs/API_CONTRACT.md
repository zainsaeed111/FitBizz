# API Contract Specification — FitBizz

This document serves as the canonical contract between the Spring Boot backend (`fitbizz_backend`) and client applications (`fitbizz_app`).

## Guidelines
* **Strict Synchronization**: Never update backend endpoints or client HTTP calls without updating this contract document.
* **No Speculative Endpoints**: Only document endpoints that are actively implemented and tested in the codebase.
* **Data Transfer Objects**: All APIs use JSON requests and responses with explicit DTO structures.

---

## Active Endpoints Status

*No API endpoints have been implemented in the current setup phase.*

When endpoints are implemented, they will be documented using the standard format:

```http
### Endpoint Name
METHOD /api/v1/resource
Headers: Content-Type: application/json

Request Body:
{
  "field": "type"
}

Response (200 OK):
{
  "id": "string",
  "status": "string"
}
```
