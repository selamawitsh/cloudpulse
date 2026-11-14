# CloudPulse User Journeys

A user journey follows one person from start to goal.

## Journey 1: Website owner, from sign-up to resolved incident

Persona: a shop owner who wants to know when the shop goes down.

```mermaid
flowchart TD
    A[Visit CloudPulse] --> B[Register]
    B --> C[Sign in]
    C --> D[Open dashboard]
    D --> E[Add a website to monitor]
    E --> F[CloudPulse saves the monitor]
    F --> G[Worker starts checking automatically]
    G --> H[User views monitoring results]
    H --> I{Does the website fail?}
    I -->|No| H
    I -->|Yes| J[Incident is created]
    J --> K[User receives email or webhook alert]
    K --> L[User reviews the incident]
    L --> M[Website recovers]
    M --> N[Incident is resolved and recorded]
```

| Step | What the user feels |
|---|---|
| Register and sign in | "This is quick and simple." |
| Add website | "I only had to type a name and address." |
| Alert arrives | "I know before my customers do." |
| Resolved | "I can see what happened and for how long." |

## Journey 2: Backend developer investigates a slow API

```mermaid
flowchart TD
    A[Sign in] --> B[Open dashboard]
    B --> C[Notice response time is rising]
    C --> D[Open the API monitor]
    D --> E[View response-time chart]
    E --> F[Filter history by date range]
    F --> G{Is it getting worse?}
    G -->|Yes| H[Compare with incident history]
    G -->|No| I[Keep monitoring]
    H --> J[Investigate the cause in the API]
```

## Journey 3: Customer checks a public status page

```mermaid
flowchart TD
    A[Customer cannot use the shop] --> B[Open the public status page link]
    B --> C[See overall status]
    C --> D{Is there an active incident?}
    D -->|Yes| E[Read incident details and start time]
    D -->|No| F[Conclude the problem is on their side]
```

## Journey 4: DevOps engineer reviews availability

```mermaid
flowchart TD
    A[Sign in] --> B[Open incident history]
    B --> C[Review start time, duration and reason]
    C --> D[Check uptime for 24h, 7d, 30d]
    D --> E[Decide what to improve]
```
