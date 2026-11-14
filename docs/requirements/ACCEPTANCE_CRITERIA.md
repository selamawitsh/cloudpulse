# CloudPulse Acceptance Criteria

## US-01: Register

- Given I am a visitor, when I submit a valid email and password,
  then my account is created.
- Given an email is already registered, when I register with it
  again, then I see a clear error and no duplicate account is made.
- Given my password is too short, when I submit, then registration
  is rejected with a clear message.

## US-03: Add a monitor

- Given I am signed in, when I submit a valid URL and interval,
  then the monitor appears in my list as "active".
- Given I submit an invalid URL, when I save, then I see a
  validation error and nothing is saved.
- Given a monitor is created, then its first check runs within
  one interval.

## US-08: Incident creation

- Given a monitor fails once, then no incident is created.
- Given a monitor fails 3 consecutive checks, then an incident is
  created with a start time.
- Given an incident is open, when 2 consecutive checks succeed,
  then the incident is resolved with an end time.

## US-10: Outage email

- Given an incident is created, then an email is sent to the
  monitor owner within 2 minutes.
- Given an incident is already open, then no repeated emails are
  sent for the same incident.

## SR-03: Data isolation

- Given user A owns a monitor, when user B requests it, then
  access is denied.
