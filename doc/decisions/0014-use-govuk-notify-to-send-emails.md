# 14. Use GOV.UK Notify to send emails

Date: 2022-10-18

## Status

Accepted

## Context

The service must keep its users updated of certain events. Updates will both
notify the user that the event has taken place, and instruct the user on how to
process the event.

For example, our initial piece of work notifies any user with the team lead role
when a new project has been created. The email contains a link to the project
information, along with detailed instructions of how to assign a caseworker to
the project.

### GOV.UK Notify

GOV.UK Notify provides a straightforward way for government departments to send
emails to users. It includes:

- an API for integration with an application.
- a web portal to manage message templates.

Emails are free to send through GOV.UK Notify.

### Maintaining a GOV.UK Notify account per service

There has been some discussion regarding a shared GOV.UK Notify account for the
entire RSD/SDD directorate. However, we believe that we should maintain an
account for each service in order to best manage the features of Notify:

- email templates
- team members
- settings
- metrics
- data exports

### Integration with Ruby on Rails

The [dxw Mail Notify library](https://github.com/dxw/mail-notify) enables easy
integration with Ruby on Rails ActionMailer.

## Decision

We will use GOV.UK Notify along with the dxw Mail Notify library. The complete
conversions, transfers and changes service will maintain its own GOV.UK Notify
account.

## Consequences

- There is unlikely to be any cost. Emails are free to send, there are no plans
  currently to send other message types.
- Developers must be provided with a GOV.UK Notify API key.
- Content designers must use the GOV.UK Notify web portal to create and edit
  email templates.
- Team member permissions must be configured and maintained in the GOV.UK Notify
  portal.
- Additional work will need to be done to configure our chosen job scheduler
  Sidekiq. The application uses the default `async` queue adapter in the
  non-production environments for ease of development.
