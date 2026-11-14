# CloudPulse Product Overview

## What is CloudPulse?

CloudPulse is a platform that continuously checks whether websites
and APIs are working. Think of it as a digital health checker for
online services.

## Purpose

Help teams detect outages before their customers do, and keep a clear
record of service health.

## Vision

Every team should be able to answer these questions at any moment:

- Is my website online?
- Is my API responding?
- How fast is it responding?
- When did it stop working, and for how long?
- Has it recovered?
- What incidents happened in the past?

## How it works (simple version)

1. A user registers a website or API address.
2. CloudPulse checks it automatically (for example, every 60 seconds).
3. It records whether the check succeeded and how long it took.
4. If checks keep failing, CloudPulse creates an incident.
5. CloudPulse notifies the user by email or webhook.
6. When the service recovers, the incident is resolved.

## Main benefits

- Find out about outages before customers complain
- Track response times and spot slowdowns
- See uptime percentage over time
- Keep a history of incidents
- Share service health through a status page

## What CloudPulse does NOT do

- It does not fix problems automatically.
- It detects, records and notifies. Humans fix.

## Two sides of the product

- **Web application:** what users see (dashboard, monitors, incidents)
- **Monitoring system:** work done in the background, even at 3:00 AM
  when nobody is using the dashboard
