# CloudPulse Requirements (Version 1)

Priority: M = Must, S = Should, C = Could

## User roles

| Role | Description |
|---|---|
| Visitor | Not signed in. Can register, sign in, view public status pages |
| User | Signed in. Manages their own monitors, incidents, notifications |
| Admin | Manages users and the platform |

---

# PART 1: FUNCTIONAL REQUIREMENTS

## 1. Authentication and accounts
- FR-01 (M): A visitor can register with email and password.
- FR-02 (M): The system rejects duplicate emails.
- FR-03 (M): A user can sign in with email and password.
- FR-04 (M): A user can sign out.
- FR-05 (M): The system keeps a user signed in with a secure
  session or token until it expires.
- FR-06 (S): A user can reset a forgotten password by email.
- FR-07 (S): A user can change their password.
- FR-08 (S): A user can update their profile (name, time zone).
- FR-09 (C): A user can delete their account and all their data.
- FR-10 (C): Email verification after registration.

## 2. Monitor management
- FR-11 (M): A user can add a monitor with name, URL and check
  interval.
- FR-12 (M): A user can choose the HTTP method (GET or HEAD).
- FR-13 (M): A user can set the expected status code (default 200).
- FR-14 (M): A user can set a request timeout.
- FR-15 (M): A user can edit a monitor.
- FR-16 (M): A user can pause and resume a monitor.
- FR-17 (M): A user can delete a monitor.
- FR-18 (M): A user can list all of their own monitors.
- FR-19 (M): A user can open a monitor to see its details.
- FR-20 (M): The system validates URLs before saving.
- FR-21 (S): A user can add custom request headers.
- FR-22 (S): A user can group monitors with tags.
- FR-23 (S): A user can search and filter monitors by name or status.
- FR-24 (C): A user can check for expected text in the response.
- FR-25 (C): A user can monitor SSL certificate expiry.

## 3. Monitoring engine
- FR-26 (M): The system checks each active monitor automatically at
  its interval, with no user action.
- FR-27 (M): Each check sends an HTTP request to the URL.
- FR-28 (M): Each check records: success or failure, HTTP status
  code, response time, and timestamp.
- FR-29 (M): A check fails if the request times out.
- FR-30 (M): A check fails if the connection or DNS fails.
- FR-31 (M): A check fails if the status code is not the expected
  one.
- FR-32 (M): Paused monitors are not checked.
- FR-33 (M): A newly created monitor is checked within one
  interval.
- FR-34 (M): A monitor's status is one of: Up, Down, Paused,
  Pending.
- FR-35 (S): Checks are spread out so many monitors do not all fire
  at the same second.
- FR-36 (C): Checks run from multiple regions.

## 4. Check history and uptime
- FR-37 (M): A user can view recent check results for a monitor.
- FR-38 (M): The system calculates uptime percentage for the last
  24 hours, 7 days and 30 days.
- FR-39 (M): The system calculates average response time over the
  same periods.
- FR-40 (S): A user can view a response-time chart.
- FR-41 (S): A user can filter history by date range.
- FR-42 (S): Old check data is deleted after a retention period
  (for example 30 days).
- FR-43 (C): A user can export history as CSV.

## 5. Incidents
- FR-44 (M): The system creates an incident after N consecutive
  failed checks (default 3).
- FR-45 (M): An incident records start time, monitor, and failure
  reason.
- FR-46 (M): Only one open incident exists per monitor at a time.
- FR-47 (M): The system resolves the incident after M consecutive
  successful checks (default 2).
- FR-48 (M): A resolved incident records end time and duration.
- FR-49 (M): A user can view open incidents.
- FR-50 (M): A user can view incident history.
- FR-51 (S): A user can view an incident timeline.
- FR-52 (S): A user can add a note to an incident.
- FR-53 (C): A user can manually acknowledge an incident.

## 6. Notifications
- FR-54 (M): The system sends an email when an incident starts.
- FR-55 (M): The system sends an email when an incident resolves.
- FR-56 (M): The system does not send repeated emails for the same
  open incident.
- FR-57 (S): A user can add a webhook URL for notifications.
- FR-58 (S): The webhook sends a JSON message with monitor,
  status and time.
- FR-59 (S): A user can turn notification channels on or off per
  monitor.
- FR-60 (S): The system retries a failed notification a few times.
- FR-61 (C): Slack or Telegram notifications.

## 7. Dashboard
- FR-62 (M): The dashboard shows all monitors with their current
  status.
- FR-63 (M): The dashboard shows overall uptime and average
  response time.
- FR-64 (M): The dashboard shows active incidents.
- FR-65 (S): The dashboard shows recent incident history.
- FR-66 (S): The dashboard refreshes automatically.

## 8. Status pages
- FR-67 (S): A user can create a public status page.
- FR-68 (S): A user can choose which monitors appear on it.
- FR-69 (S): A status page is readable without signing in.
- FR-70 (S): A status page shows current status and recent
  incidents.
- FR-71 (C): Custom status page title and description.

## 9. Admin
- FR-72 (C): An admin can list users.
- FR-73 (C): An admin can disable a user.
- FR-74 (C): An admin can view system health.

## 10. API
- FR-75 (M): All features are available through a REST API.
- FR-76 (M): The API returns consistent JSON responses.
- FR-77 (M): The API returns correct HTTP status codes.
- FR-78 (M): The API returns clear error messages.
- FR-79 (S): The API supports pagination for long lists.
- FR-80 (S): The API exposes a health endpoint (for example
  `/health`).

---

# PART 2: NON-FUNCTIONAL REQUIREMENTS

## Performance
- NFR-01 (M): The dashboard loads in under 3 seconds under normal use.
- NFR-02 (M): Normal API requests respond in under 500 ms.
- NFR-03 (M): Background checks never slow down the dashboard.

## Reliability and availability
- NFR-04 (M): Monitoring continues when no user is signed in.
- NFR-05 (M): One failed check does not create an incident (avoid
  false alarms).
- NFR-06 (M): If a worker crashes, it restarts and monitoring
  resumes.
- NFR-07 (M): A failure in one notification channel does not stop
  other channels.
- NFR-08 (S): The system itself targets 99% availability.

## Accuracy
- NFR-09 (M): Response time is measured consistently for every
  check.
- NFR-10 (M): Uptime is calculated from stored check results.
- NFR-11 (M): Timestamps are stored in UTC and shown in the user's
  time zone.

## Scalability
- NFR-12 (M): Checks run as background jobs separate from the web
  request flow.
- NFR-13 (S): The worker can be scaled to more instances.
- NFR-14 (S): Version 1 supports at least 100 monitors per
  instance.

## Usability
- NFR-15 (M): Adding a monitor takes few steps and uses clear
  wording.
- NFR-16 (M): Error messages are understandable to non-experts.
- NFR-17 (S): The interface works on desktop and mobile screens.
- NFR-18 (S): Colors are not the only way status is shown
  (accessibility).

## Maintainability and quality
- NFR-19 (M): Code is organized in clear layers and folders.
- NFR-20 (M): Automated tests cover core backend logic.
- NFR-21 (M): The database changes through versioned migrations.
- NFR-22 (M): Configuration comes from environment variables, not
  hard-coded values.
- NFR-23 (S): Code style is checked automatically.

## Portability and deployment
- NFR-24 (M): Every component runs in a Docker container.
- NFR-25 (M): The whole system starts locally with one Docker
  Compose command.
- NFR-26 (M): CI tests every pull request.
- NFR-27 (M): Deployment is automated through a pipeline.
- NFR-28 (S): A bad deployment can be rolled back.

## Observability
- NFR-29 (M): The backend writes structured application logs.
- NFR-30 (M): Every service has a health check.
- NFR-31 (S): Key metrics are collected (request count, errors,
  check duration).
- NFR-32 (S): Alerts exist for CloudPulse's own failures.

## Data
- NFR-33 (M): Data is stored in PostgreSQL and survives container
  restarts (persistent volume).
- NFR-34 (S): The database is backed up regularly.
- NFR-35 (S): A backup can be restored and this is tested.

## Compatibility
- NFR-36 (S): The dashboard works in current Chrome, Firefox,
  Safari and Edge.

## Cost
- NFR-37 (M): The AWS deployment stays within a small budget, with
  billing alerts enabled.

## Documentation
- NFR-38 (M): README explains how to run the project.
- NFR-39 (M): Architecture, API and operations are documented.
- NFR-40 (S): Runbooks explain how to troubleshoot common failures.

---

# PART 3: SECURITY REQUIREMENTS

- SR-01 (M): Passwords are hashed with a strong algorithm (for
  example BCrypt), never stored as plain text.
- SR-02 (M): Protected APIs and pages require authentication.
- SR-03 (M): A user can never read or change another user's data.
- SR-04 (M): All user input is validated on the backend.
- SR-05 (M): Secrets (passwords, keys, tokens) are never committed
  to Git.
- SR-06 (M): Production traffic uses HTTPS.
- SR-07 (M): Database queries are protected against SQL injection.
- SR-08 (M): Login attempts are rate limited.
- SR-09 (M): Error messages do not leak internal details.
- SR-10 (M): Sessions or tokens expire.
- SR-11 (S): The system blocks monitoring of private or internal
  addresses (for example `localhost`, `10.x.x.x`) so users cannot
  use CloudPulse to probe internal networks (SSRF protection).
- SR-12 (S): Security headers are set (for example by Nginx).
- SR-13 (S): CORS allows only the known frontend.
- SR-14 (S): Containers run as a non-root user.
- SR-15 (S): Dependencies are scanned for known vulnerabilities.
- SR-16 (S): AWS access follows least privilege (IAM).
- SR-17 (S): The database is not reachable from the public internet.
- SR-18 (C): Audit log of important actions.
