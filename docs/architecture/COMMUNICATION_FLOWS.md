# CloudPulse Communication Flows

## 1. Sign in

```mermaid
sequenceDiagram
    participant B as Browser
    participant N as Nginx
    participant A as API
    participant D as PostgreSQL

    B->>N: POST /api/auth/login (email, password)
    N->>A: forward request
    A->>D: find user by email
    D-->>A: user with password hash
    A->>A: compare password with hash
    A-->>N: 200 OK, secure cookie with token
    N-->>B: response
```

## 2. Add a monitor

```mermaid
sequenceDiagram
    participant B as Browser
    participant A as API
    participant D as PostgreSQL

    B->>A: POST /api/monitors (name, url, interval)
    A->>A: check token, validate input
    A->>D: insert monitor for this user
    D-->>A: saved
    A-->>B: 201 Created
```

## 3. Scheduled check (no user involved)

```mermaid
sequenceDiagram
    participant S as Scheduler
    participant D as PostgreSQL
    participant R as Redis
    participant W as Worker thread
    participant T as Target website

    S->>D: which active monitors are due?
    D-->>S: monitors 42, 43
    S->>R: push job "check 42", "check 43"
    W->>R: take next job
    W->>R: get lock for monitor 42
    W->>T: HTTP request
    T-->>W: status code and time
    W->>D: save check result
    W->>W: apply failure rules
    W->>D: open or resolve incident if needed
    W->>R: release lock
```

## 4. Incident notification

```mermaid
sequenceDiagram
    participant W as Worker
    participant D as PostgreSQL
    participant M as Email server
    participant H as Webhook URL

    W->>D: create incident
    W->>D: load notification channels for this monitor
    W->>M: send email
    W->>H: POST JSON message
    W->>D: record that notification was sent
```

## 5. Open the dashboard

```mermaid
sequenceDiagram
    participant B as Browser
    participant A as API
    participant D as PostgreSQL

    B->>A: GET /api/dashboard
    A->>D: monitors, latest status, uptime numbers
    D-->>A: data
    A-->>B: 200 OK with JSON
    B->>B: draw cards and charts
```

## Who talks to whom

| From | To | Protocol |
|---|---|---|
| Browser | Nginx | HTTP, later HTTPS |
| Nginx | Frontend, API | HTTP |
| API, Worker | PostgreSQL | SQL over TCP |
| API, Worker | Redis | Redis protocol over TCP |
| Worker | Target websites | HTTP or HTTPS |
| Worker | Email server | SMTP |
| Worker | Webhook URLs | HTTPS POST |
