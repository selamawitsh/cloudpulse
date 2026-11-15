# CloudPulse Component Architecture

## Backend layers

Every request passes through the same layers.

```mermaid
flowchart LR
    C[Controller<br/>receives HTTP request] --> S[Service<br/>business rules]
    S --> R[Repository<br/>database access]
    R --> D[(PostgreSQL)]
```

| Layer | Job | Must NOT do |
|---|---|---|
| Controller | Read request, validate input, return response | Business rules |
| Service | Apply rules (for example the 3-failure rule) | Build HTTP responses |
| Repository | Read and write the database | Business rules |

## Backend modules (organized by feature)

```mermaid
flowchart TD
    subgraph Backend["Spring Boot codebase"]
        Auth[auth<br/>register, login, tokens]
        Monitor[monitor<br/>CRUD for monitors]
        Check[check<br/>run checks, store results]
        Incident[incident<br/>open and resolve]
        Notify[notification<br/>email and webhook]
        Status[statuspage<br/>public pages]
        Common[common<br/>errors, security, config]
    end
    Check --> Incident
    Incident --> Notify
    Monitor --> Check
```

## Two ways to run the same codebase

| Process | Runs | Exposes web port? |
|---|---|---|
| API | Controllers, auth, REST endpoints | Yes |
| Worker | Scheduler, check runner, incident rules, notifications | No (health check only) |

The choice is made with a configuration value (a Spring profile), so one
Docker image can start either process.

## Worker internals

```mermaid
flowchart TD
    Sch[Scheduler<br/>finds monitors that are due] --> Q[(Redis queue)]
    Q --> Pool[Worker threads<br/>take jobs from the queue]
    Pool --> Run[Check runner<br/>sends HTTP request, measures time]
    Run --> Save[Save result in PostgreSQL]
    Save --> Rules[Failure rules<br/>3 fails open, 2 successes resolve]
    Rules --> Inc[Create or resolve incident]
    Inc --> Not[Send notification]
```

Redis also holds a **lock** per monitor, so if we later run two workers
they never check the same monitor at the same time.
