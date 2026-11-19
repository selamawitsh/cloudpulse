# CloudPulse API Endpoints

## Summary

| # | Method | Path | Auth | Success | Purpose |
|---|---|---|---|---|---|
| 1 | POST | /api/auth/register | No | 201 | Create account |
| 2 | POST | /api/auth/login | No | 200 | Sign in |
| 3 | POST | /api/auth/logout | Yes | 204 | Sign out |
| 4 | GET | /api/auth/me | Yes | 200 | Current user |
| 5 | GET | /api/monitors | Yes | 200 | List my monitors |
| 6 | POST | /api/monitors | Yes | 201 | Add a monitor |
| 7 | GET | /api/monitors/{id} | Yes | 200 | Monitor details |
| 8 | PUT | /api/monitors/{id} | Yes | 200 | Edit a monitor |
| 9 | DELETE | /api/monitors/{id} | Yes | 204 | Delete a monitor |
| 10 | POST | /api/monitors/{id}/pause | Yes | 200 | Pause |
| 11 | POST | /api/monitors/{id}/resume | Yes | 200 | Resume |
| 12 | GET | /api/monitors/{id}/checks | Yes | 200 | Check history |
| 13 | GET | /api/monitors/{id}/stats | Yes | 200 | Uptime and response time |
| 14 | GET | /api/monitors/{id}/response-times | Yes | 200 | Chart data |
| 15 | PUT | /api/monitors/{id}/notification-channels | Yes | 200 | Choose channels |
| 16 | GET | /api/incidents | Yes | 200 | List incidents |
| 17 | GET | /api/incidents/{id} | Yes | 200 | Incident details |
| 18 | GET | /api/notification-channels | Yes | 200 | List channels |
| 19 | POST | /api/notification-channels | Yes | 201 | Add channel |
| 20 | DELETE | /api/notification-channels/{id} | Yes | 204 | Remove channel |
| 21 | GET | /api/dashboard | Yes | 200 | Dashboard summary |
| 22 | GET | /api/status-pages | Yes | 200 | List my status pages |
| 23 | POST | /api/status-pages | Yes | 201 | Create status page |
| 24 | PUT | /api/status-pages/{id} | Yes | 200 | Edit status page |
| 25 | DELETE | /api/status-pages/{id} | Yes | 204 | Delete status page |
| 26 | GET | /api/public/status/{slug} | No | 200 | Public status page |
| 27 | GET | /api/health | No | 200 | Health check |

---

## 1. Register

`POST /api/auth/register`

Request:

```json
{ "email": "selam@example.com", "password": "StrongPass123", "displayName": "Selam" }
```

Response `201`:

```json
{ "id": "3f2b8c1e-7a4d-4e9b-9c11-2d5f6a8b9c10", "email": "selam@example.com", "displayName": "Selam" }
```

Errors: `400` invalid input, `409` email already registered.

## 2. Login

`POST /api/auth/login`

Request:

```json
{ "email": "selam@example.com", "password": "StrongPass123" }
```

Response `200` (cookie is set in the response headers):

```json
{ "id": "3f2b8c1e-7a4d-4e9b-9c11-2d5f6a8b9c10", "email": "selam@example.com", "displayName": "Selam" }
```

Errors: `401` wrong email or password (same message for both),
`429` too many attempts.

## 6. Add a monitor

`POST /api/monitors`

Request:

```json
{
  "name": "Payment API",
  "url": "https://payments.example.com/health",
  "httpMethod": "GET",
  "expectedStatusCode": 200,
  "intervalSeconds": 60,
  "timeoutSeconds": 10
}
```

Response `201`:

```json
{
  "id": "9a1d5c20-1b3e-4f6a-8d77-0c2e4b6a8d10",
  "name": "Payment API",
  "url": "https://payments.example.com/health",
  "httpMethod": "GET",
  "expectedStatusCode": 200,
  "intervalSeconds": 60,
  "timeoutSeconds": 10,
  "status": "PENDING",
  "lastCheckedAt": null,
  "createdAt": "2026-11-19T10:00:00Z"
}
```

Errors: `400` invalid input, `401` not signed in.

## 5. List monitors

`GET /api/monitors?status=DOWN&search=pay&page=0&size=20`

Response `200`: a paginated list of monitor objects (shape above).

## 10. Pause a monitor

`POST /api/monitors/{id}/pause`

Response `200`: the monitor with `"status": "PAUSED"`.
Errors: `404` not found or not yours.

## 12. Check history

`GET /api/monitors/{id}/checks?from=2026-11-18T00:00:00Z&to=2026-11-19T00:00:00Z&page=0&size=50`

Response `200`:

```json
{
  "items": [
    {
      "id": 88213,
      "checkedAt": "2026-11-19T10:02:00Z",
      "success": false,
      "statusCode": 503,
      "responseTimeMs": 1250,
      "errorMessage": "Unexpected status code 503"
    }
  ],
  "page": 0,
  "size": 50,
  "totalItems": 1440,
  "totalPages": 29
}
```

## 13. Monitor statistics

`GET /api/monitors/{id}/stats`

Response `200`:

```json
{
  "uptime24h": 99.93,
  "uptime7d": 99.82,
  "uptime30d": 99.5,
  "avgResponseTimeMs24h": 245
}
```

## 14. Response-time chart data

`GET /api/monitors/{id}/response-times?range=24h`

`range` is one of `24h`, `7d`, `30d`.

```json
{
  "range": "24h",
  "points": [
    { "time": "2026-11-19T09:00:00Z", "avgResponseTimeMs": 230 },
    { "time": "2026-11-19T10:00:00Z", "avgResponseTimeMs": 260 }
  ]
}
```

## 16. List incidents

`GET /api/incidents?status=OPEN&monitorId=9a1d5c20-...&page=0&size=20`

Response `200` item:

```json
{
  "id": "c4e1a7d2-5b9f-4a31-8e62-7f0d1b3c5a90",
  "monitorId": "9a1d5c20-1b3e-4f6a-8d77-0c2e4b6a8d10",
  "monitorName": "Payment API",
  "status": "RESOLVED",
  "startedAt": "2026-11-19T10:03:00Z",
  "resolvedAt": "2026-11-19T10:09:00Z",
  "durationSeconds": 360,
  "failureReason": "Unexpected status code 503"
}
```

## 19. Add a notification channel

`POST /api/notification-channels`

```json
{ "type": "WEBHOOK", "target": "https://hooks.example.com/cloudpulse" }
```

Response `201`: the channel with its `id` and `enabled: true`.
Errors: `400` invalid target, `409` channel already exists.

## 21. Dashboard

`GET /api/dashboard`

Response `200`:

```json
{
  "totalMonitors": 3,
  "monitorsUp": 2,
  "monitorsDown": 1,
  "monitorsPaused": 0,
  "overallUptime24h": 99.82,
  "avgResponseTimeMs24h": 245,
  "activeIncidents": [
    {
      "id": "c4e1a7d2-5b9f-4a31-8e62-7f0d1b3c5a90",
      "monitorName": "Payment API",
      "startedAt": "2026-11-19T10:03:00Z"
    }
  ],
  "monitors": [
    { "id": "9a1d5c20-...", "name": "Payment API", "status": "DOWN", "lastCheckedAt": "2026-11-19T10:04:00Z" }
  ]
}
```

## 23. Create a status page

`POST /api/status-pages`

```json
{
  "slug": "my-shop",
  "title": "My Shop Status",
  "description": "Live status of our services",
  "published": true,
  "monitorIds": ["9a1d5c20-...", "7b2e6d31-..."]
}
```

Response `201`: the status page with its `id`.
Errors: `409` slug already taken.

## 26. Public status page

`GET /api/public/status/{slug}` (no sign-in)

Response `200`:

```json
{
  "title": "My Shop Status",
  "description": "Live status of our services",
  "overallStatus": "PARTIAL_OUTAGE",
  "monitors": [
    { "name": "Website", "status": "UP" },
    { "name": "Payment API", "status": "DOWN" }
  ],
  "recentIncidents": [
    { "monitorName": "Payment API", "status": "OPEN", "startedAt": "2026-11-19T10:03:00Z" }
  ]
}
```

`overallStatus` is `OPERATIONAL`, `PARTIAL_OUTAGE` or `MAJOR_OUTAGE`.
The public response never includes URLs, emails or other private data.
Errors: `404` if the page does not exist or is not published.

## 27. Health

`GET /api/health` returns `200` with `{ "status": "UP" }`.
