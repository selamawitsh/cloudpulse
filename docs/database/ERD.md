# CloudPulse Entity Relationship Diagram

```mermaid
erDiagram
    USERS ||--o{ MONITORS : owns
    USERS ||--o{ NOTIFICATION_CHANNELS : configures
    USERS ||--o{ STATUS_PAGES : creates
    MONITORS ||--o{ CHECK_RESULTS : has
    MONITORS ||--o{ INCIDENTS : has
    MONITORS ||--o{ MONITOR_NOTIFICATION_CHANNELS : uses
    NOTIFICATION_CHANNELS ||--o{ MONITOR_NOTIFICATION_CHANNELS : used_by
    STATUS_PAGES ||--o{ STATUS_PAGE_MONITORS : shows
    MONITORS ||--o{ STATUS_PAGE_MONITORS : shown_on
    INCIDENTS ||--o{ NOTIFICATION_EVENTS : triggers
    NOTIFICATION_CHANNELS ||--o{ NOTIFICATION_EVENTS : delivers

    USERS {
        uuid id PK
        varchar email UK
        varchar password_hash
        varchar display_name
        varchar time_zone
        varchar role
        boolean enabled
        timestamptz created_at
        timestamptz updated_at
    }
    MONITORS {
        uuid id PK
        uuid user_id FK
        varchar name
        varchar url
        varchar http_method
        int expected_status_code
        int interval_seconds
        int timeout_seconds
        varchar status
        int consecutive_failures
        int consecutive_successes
        timestamptz next_check_at
        timestamptz last_checked_at
        timestamptz created_at
        timestamptz updated_at
    }
    CHECK_RESULTS {
        bigint id PK
        uuid monitor_id FK
        timestamptz checked_at
        boolean success
        int status_code
        int response_time_ms
        varchar error_message
    }
    INCIDENTS {
        uuid id PK
        uuid monitor_id FK
        varchar status
        timestamptz started_at
        timestamptz resolved_at
        varchar failure_reason
        timestamptz created_at
    }
    NOTIFICATION_CHANNELS {
        uuid id PK
        uuid user_id FK
        varchar type
        varchar target
        boolean enabled
        timestamptz created_at
    }
    MONITOR_NOTIFICATION_CHANNELS {
        uuid monitor_id PK
        uuid channel_id PK
    }
    NOTIFICATION_EVENTS {
        bigint id PK
        uuid incident_id FK
        uuid channel_id FK
        varchar event_type
        varchar status
        varchar error_message
        timestamptz created_at
    }
    STATUS_PAGES {
        uuid id PK
        uuid user_id FK
        varchar slug UK
        varchar title
        varchar description
        boolean published
        timestamptz created_at
        timestamptz updated_at
    }
    STATUS_PAGE_MONITORS {
        uuid status_page_id PK
        uuid monitor_id PK
        int display_order
    }
```

## How to read the lines

`||--o{` means **one to many**: exactly one on the left, zero or many on
the right. Example: one user owns many monitors.

## Relationships

| Relationship | Type | How it is stored |
|---|---|---|
| User to monitors | One-to-many | `monitors.user_id` |
| Monitor to check results | One-to-many | `check_results.monitor_id` |
| Monitor to incidents | One-to-many | `incidents.monitor_id` |
| User to notification channels | One-to-many | `notification_channels.user_id` |
| Monitors and channels | Many-to-many | `monitor_notification_channels` |
| Status pages and monitors | Many-to-many | `status_page_monitors` |
| Incident to notification events | One-to-many | `notification_events.incident_id` |

## Design notes

- **Deleting cascades.** Deleting a user deletes their monitors, and
  deleting a monitor deletes its results and incidents (`ON DELETE CASCADE`).
- **One open incident per monitor** is enforced by the database itself
  with a partial unique index (requirement FR-46).
- **No duplicate alerts**: a unique index stops the same notification
  being recorded as sent twice (requirement FR-56).
- **Deliberate denormalization:** `consecutive_failures` and
  `consecutive_successes` live on `monitors` so the worker does not
  recount history every minute.
- **Uptime is calculated, not stored:** it comes from `check_results`
  (requirement NFR-10).
- **Retention:** a scheduled job deletes `check_results` older than
  30 days (requirement FR-42).
- **All timestamps are UTC** (`timestamptz`) (requirement NFR-11).
- **Later (not version 1):** custom request headers, incident notes,
  password reset tokens, tags.
