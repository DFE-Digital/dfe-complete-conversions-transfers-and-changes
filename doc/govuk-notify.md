# GOV.UK Notifications

The applications uses [GOV.UK Notify](https://www.notifications.service.gov.uk)
to send emails.

Our service dashboard:

https://www.notifications.service.gov.uk/services/32d75f94-b459-4e65-b753-3f9d55c8c9b7

## About

Notify works in various 'modes' via the API keys and we leverage this to handle
sending (or not) emails in our environments:

- local development uses a 'Team and guest' API key that can send to the team
  email addresses (in Notify) and other 'guest' addresses only.
- development uses a 'Test' API key, the application thinks the emails are sent
  but they are not, a record and the actual email can be viewed in the Notify
  UI.
- test users a 'Test' API key, as above
- production uses a 'Live' API key and is the only environment where we actually
  send the emails.

## How

We use the [dxw mail notify](https://github.com/dxw/mail-notify) gem as an
ActiveMailer abstraction of the Notify Ruby API.

Emails are queued via [Sidekiq](https://github.com/sidekiq/sidekiq) with
ActiveJob.

## Getting access to Notify

At least one member of the team, including the Product owner should have access
and can get you added to the team.
