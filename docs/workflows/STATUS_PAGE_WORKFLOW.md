# CloudPulse Status Page Workflow

## Owner creates a status page

```mermaid
flowchart TD
    A[User signs in] --> B[Open status pages]
    B --> C[Create status page with title]
    C --> D[Choose which monitors to show]
    D --> E[Publish]
    E --> F[System creates a public link]
    F --> G[User shares the link with customers]
```

## Visitor opens the page

```mermaid
flowchart TD
    A[Visitor opens public link] --> B[System finds the page]
    B --> C{Page exists and is published?}
    C -->|No| D[Show Not Found]
    C -->|Yes| E[Load chosen monitors and recent incidents]
    E --> F[Work out overall status]
    F --> G[Show status page, no sign-in needed]
```

## Overall status rules

| Situation | Overall status |
|---|---|
| All monitors Up | Operational |
| Some monitors Down | Partial outage |
| All monitors Down | Major outage |
| Paused monitors | Not counted |

## Privacy rule

A public page shows only the monitors the owner chose, and never
shows private data such as email addresses or request headers.
