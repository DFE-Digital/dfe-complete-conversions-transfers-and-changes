# 11. Use Sentry.io for error reporting

Date: 2022-08-24

## Status

Accepted

## Context

Monitoring errors that occur an application is a vital troubleshooting tool both
in development and later when live.

Many services exist to make this process as friction free as possible.

RSD already have their applications in Sentry, so it makes sense to add ours
there as well.

## Decision

We will use [Sentry](https://sentry.io) for error reporting.

## Consequences

- Onboarding new developers will involved granting access to the appropriate
  Sentry team and project.
- There may be a cost associated with the service.
