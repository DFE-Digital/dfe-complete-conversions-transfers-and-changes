# 19. Manage user accounts locally

Date: 2023-07-06

## Status

Accepted

## Context

The applicaiton models a user as both an end user of the applicatiion and data
stored within the application.

The DfE Active Directory is used to authenticate users, see
[ADR 0003 User sign in](0003-user-sign-in.md).

The team looked to authorise uses in the application using new or existing
Active Directory groups, but the governance around these was found to cumbersome
which it was felt would lead to unacceptable delays for users being on-boarded
or updated.

## Decision

Users will be stored and managed locally within the application. The data will
be used to authorise users and to retain a record of users and how they relate
to the data held within the application.

Initially, the delivery team will manage the users accounts, with a long term
strategy to hand the responsibility over to the Service Support team, who will
be responsible for supporting the application anyway.

## Consequences

- the application will effectively be duplicate user data
- there will a support burden to maintain the user list
