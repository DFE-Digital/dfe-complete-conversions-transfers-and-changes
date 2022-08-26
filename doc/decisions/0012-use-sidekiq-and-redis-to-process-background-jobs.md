# 11. Use Sidekiq and Redis to process background jobs

Date: 2022-08-26

## Status

Accepted

## Context

Most web applications have a need to send email notifications and we can already
see the points in out journey where we would like to do so.

Best practice when sending email is to do so on a background job, this prevents
the application having to wait for the email to be sent in order to continue
execution.

The most common way to approach this is to use Rails own
[ActiveJob](https://guides.rubyonrails.org/active_job_basics.html) along with
[Sidekiq](https://sidekiq.org/) which depends on Redis.

## Decision

We will adopt the standard approach to this and setup ActiveJob, Sidekiq and
Redis. Now is a good time to do this as we are about start work on our
Production environments and doing this work now will mean we do not need to come
back later.

## Consequences

- Standard approach
- Removes the need to return to our production environments later to add
  background jobs
- Increased complexity
- Redis will be a new dependency
- There is risk we will not find the space in delivery to utilise the background
  jobs
