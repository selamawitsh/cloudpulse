# CloudPulse Incident Workflow

## Monitor states

```mermaid
stateDiagram-v2
    [*] --> Pending: monitor created
    Pending --> Up: first check succeeds
    Pending --> Down: first checks fail
    Up --> Down: incident created
    Down --> Up: incident resolved
    Up --> Paused: user pauses
    Down --> Paused: user pauses
    Paused --> Pending: user resumes
```

## Incident states

```mermaid
stateDiagram-v2
    [*] --> Open: 3 consecutive failures
    Open --> Resolved: 2 consecutive successes
    Resolved --> [*]
```

## What happens after every check

```mermaid
flowchart TD
    A[Check runs] --> B{Did it succeed?}
    B -->|Yes| C[Reset failure counter to 0]
    C --> D[Add 1 to success counter]
    D --> E{Open incident AND successes >= 2?}
    E -->|Yes| F[Resolve incident, record end time]
    F --> G[Send recovery notification]
    E -->|No| Z[Save result and wait for next check]
    B -->|No| H[Reset success counter to 0]
    H --> I[Add 1 to failure counter]
    I --> J{Failures >= 3 AND no open incident?}
    J -->|Yes| K[Create incident, record start time]
    K --> L[Send outage notification]
    J -->|No| Z
    G --> Z
    L --> Z
```

## Timeline example

| Time | Result | Failures | Event |
|---|---|---|---|
| 10:00 | Success | 0 | Nothing |
| 10:01 | Fail | 1 | Nothing (could be a glitch) |
| 10:02 | Fail | 2 | Nothing |
| 10:03 | Fail | 3 | Incident created, alert sent |
| 10:04 | Fail | 4 | Nothing (no duplicate alert) |
| 10:05 | Success | 0 (success 1) | Nothing yet |
| 10:06 | Success | success 2 | Incident resolved, recovery alert |

## What counts as a failed check

- Request times out
- DNS or connection error
- Status code is not the expected one

## Check flow between components

```mermaid
sequenceDiagram
    participant S as Scheduler
    participant W as Worker
    participant T as Target website
    participant D as Database
    participant N as Notifier

    S->>W: Time to check monitor 42
    W->>T: HTTP request
    T-->>W: Response (or timeout)
    W->>D: Save result
    W->>W: Apply failure rules
    W->>D: Create or resolve incident if needed
    W->>N: Send alert if needed
```

The rules (3 failures, 2 successes) are settings. We tune them in Phase 8.
