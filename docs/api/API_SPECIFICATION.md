# CloudPulse API Specification

## General rules

- Base path: `/api`
- Format: JSON for requests and responses
- Field names: `camelCase`
- Times: ISO 8601 in UTC, for example `2026-11-19T10:03:00Z`
- IDs: UUID strings (check results use numbers)

## Authentication

- `POST /api/auth/login` sets a secure, HTTP-only cookie with a token.
- The browser sends the cookie automatically on later requests.
- Public endpoints need no cookie: register, login, health and
  `/api/public/**`.
- Every other endpoint needs a valid cookie, or the API returns `401`.

## Ownership rule

A user can only see and change their own data. If a user asks for
another user's resource, the API returns `404` (not `403`), so it does
not reveal that the resource exists (security requirement SR-03).

## HTTP methods

| Method | Use |
|---|---|
| GET | Read, no changes |
| POST | Create, or run an action such as pause |
| PUT | Update an existing resource |
| DELETE | Remove a resource |

## Status codes

| Code | When |
|---|---|
| 200 OK | Successful read, update or action |
| 201 Created | New resource created |
| 204 No Content | Success with no body (delete, logout) |
| 400 Bad Request | Invalid input |
| 401 Unauthorized | Not signed in or token expired |
| 403 Forbidden | Signed in but role not allowed (admin only) |
| 404 Not Found | Resource missing or not yours |
| 409 Conflict | Duplicate, for example email already registered |
| 429 Too Many Requests | Rate limit reached |
| 500 Internal Server Error | Unexpected server problem |

## Error format

Every error uses the same shape:

```json
{
  "timestamp": "2026-11-19T10:03:00Z",
  "status": 400,
  "error": "VALIDATION_ERROR",
  "message": "Request validation failed",
  "details": [
    { "field": "url", "message": "must be a valid http or https URL" }
  ]
}
```

Errors never contain stack traces or internal details (SR-09).

## Pagination

List endpoints accept `page` (starts at 0) and `size` (default 20,
maximum 100). They return:

```json
{
  "items": [],
  "page": 0,
  "size": 20,
  "totalItems": 57,
  "totalPages": 3
}
```

## Validation rules

| Field | Rule |
|---|---|
| email | Valid format, maximum 255 characters |
| password | 8 to 72 characters |
| monitor name | 1 to 100 characters |
| monitor url | `http` or `https`, maximum 2048 characters, must not point to a private or internal address |
| intervalSeconds | 30 to 3600 |
| timeoutSeconds | 1 to 60 |
| slug | lowercase letters, numbers and hyphens |
