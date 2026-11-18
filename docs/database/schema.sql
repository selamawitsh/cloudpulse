-- CloudPulse database schema (PostgreSQL 13+)

CREATE TABLE users (
    id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email         VARCHAR(255) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    display_name  VARCHAR(100),
    time_zone     VARCHAR(50)  NOT NULL DEFAULT 'UTC',
    role          VARCHAR(20)  NOT NULL DEFAULT 'USER'
                  CHECK (role IN ('USER', 'ADMIN')),
    enabled       BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at    TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at    TIMESTAMPTZ  NOT NULL DEFAULT now()
);

-- Emails are unique regardless of upper or lower case
CREATE UNIQUE INDEX uq_users_email ON users (lower(email));

CREATE TABLE monitors (
    id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id               UUID NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    name                  VARCHAR(100)  NOT NULL,
    url                   VARCHAR(2048) NOT NULL,
    http_method           VARCHAR(10)   NOT NULL DEFAULT 'GET'
                          CHECK (http_method IN ('GET', 'HEAD')),
    expected_status_code  INT           NOT NULL DEFAULT 200
                          CHECK (expected_status_code BETWEEN 100 AND 599),
    interval_seconds      INT           NOT NULL DEFAULT 60
                          CHECK (interval_seconds BETWEEN 30 AND 3600),
    timeout_seconds       INT           NOT NULL DEFAULT 10
                          CHECK (timeout_seconds BETWEEN 1 AND 60),
    status                VARCHAR(20)   NOT NULL DEFAULT 'PENDING'
                          CHECK (status IN ('PENDING', 'UP', 'DOWN', 'PAUSED')),
    consecutive_failures  INT           NOT NULL DEFAULT 0 CHECK (consecutive_failures >= 0),
    consecutive_successes INT           NOT NULL DEFAULT 0 CHECK (consecutive_successes >= 0),
    next_check_at         TIMESTAMPTZ,
    last_checked_at       TIMESTAMPTZ,
    created_at            TIMESTAMPTZ   NOT NULL DEFAULT now(),
    updated_at            TIMESTAMPTZ   NOT NULL DEFAULT now()
);

CREATE INDEX idx_monitors_user_id ON monitors (user_id);

-- The scheduler looks for monitors that are due; paused ones are skipped
CREATE INDEX idx_monitors_due ON monitors (next_check_at) WHERE status <> 'PAUSED';

CREATE TABLE check_results (
    id               BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    monitor_id       UUID        NOT NULL REFERENCES monitors (id) ON DELETE CASCADE,
    checked_at       TIMESTAMPTZ NOT NULL,
    success          BOOLEAN     NOT NULL,
    status_code      INT,
    response_time_ms INT,
    error_message    VARCHAR(500)
);

CREATE INDEX idx_check_results_monitor_time ON check_results (monitor_id, checked_at DESC);
CREATE INDEX idx_check_results_checked_at   ON check_results (checked_at);

CREATE TABLE incidents (
    id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    monitor_id     UUID        NOT NULL REFERENCES monitors (id) ON DELETE CASCADE,
    status         VARCHAR(20) NOT NULL DEFAULT 'OPEN'
                   CHECK (status IN ('OPEN', 'RESOLVED')),
    started_at     TIMESTAMPTZ NOT NULL,
    resolved_at    TIMESTAMPTZ,
    failure_reason VARCHAR(500),
    created_at     TIMESTAMPTZ NOT NULL DEFAULT now(),
    CHECK (
        (status = 'OPEN'     AND resolved_at IS NULL) OR
        (status = 'RESOLVED' AND resolved_at IS NOT NULL)
    )
);

CREATE INDEX idx_incidents_monitor_started ON incidents (monitor_id, started_at DESC);

-- Only one open incident per monitor
CREATE UNIQUE INDEX uq_incidents_one_open_per_monitor
    ON incidents (monitor_id) WHERE status = 'OPEN';

CREATE TABLE notification_channels (
    id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id    UUID          NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    type       VARCHAR(20)   NOT NULL CHECK (type IN ('EMAIL', 'WEBHOOK')),
    target     VARCHAR(2048) NOT NULL,   -- email address or webhook URL
    enabled    BOOLEAN       NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ   NOT NULL DEFAULT now(),
    UNIQUE (user_id, type, target)
);

-- Many-to-many: which channels notify for which monitor
CREATE TABLE monitor_notification_channels (
    monitor_id UUID NOT NULL REFERENCES monitors (id) ON DELETE CASCADE,
    channel_id UUID NOT NULL REFERENCES notification_channels (id) ON DELETE CASCADE,
    PRIMARY KEY (monitor_id, channel_id)
);

CREATE TABLE notification_events (
    id            BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    incident_id   UUID        NOT NULL REFERENCES incidents (id) ON DELETE CASCADE,
    channel_id    UUID        NOT NULL REFERENCES notification_channels (id) ON DELETE CASCADE,
    event_type    VARCHAR(30) NOT NULL
                  CHECK (event_type IN ('INCIDENT_OPENED', 'INCIDENT_RESOLVED')),
    status        VARCHAR(20) NOT NULL CHECK (status IN ('SENT', 'FAILED')),
    error_message VARCHAR(500),
    created_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- The same notification is never recorded as sent twice
CREATE UNIQUE INDEX uq_notification_sent_once
    ON notification_events (incident_id, channel_id, event_type) WHERE status = 'SENT';

CREATE TABLE status_pages (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id     UUID         NOT NULL REFERENCES users (id) ON DELETE CASCADE,
    slug        VARCHAR(100) NOT NULL UNIQUE
                CHECK (slug ~ '^[a-z0-9]+(-[a-z0-9]+)*$'),
    title       VARCHAR(150) NOT NULL,
    description VARCHAR(500),
    published   BOOLEAN      NOT NULL DEFAULT FALSE,
    created_at  TIMESTAMPTZ  NOT NULL DEFAULT now(),
    updated_at  TIMESTAMPTZ  NOT NULL DEFAULT now()
);

-- Many-to-many: which monitors appear on which status page
CREATE TABLE status_page_monitors (
    status_page_id UUID NOT NULL REFERENCES status_pages (id) ON DELETE CASCADE,
    monitor_id     UUID NOT NULL REFERENCES monitors (id) ON DELETE CASCADE,
    display_order  INT  NOT NULL DEFAULT 0,
    PRIMARY KEY (status_page_id, monitor_id)
);
