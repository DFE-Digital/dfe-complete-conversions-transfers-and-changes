# 4. Use pundit gem to manage authorisation

Date: 2022-07-07

## Status

Accepted

## Context

During research, users have indicated a potential need for only some types of
users (team leaders) to be able to perform certain actions, and for other users
to only be presented with a list of projects they are currently working on.

Ideally, this functionality would be provided by a lightweight layer which
authorises a user (who meets a given set of criteria) to perform actions.

## Decision

We have decided to implement user authorisation management using the
[pundit](https://github.com/varvet/pundit) gem.

## Consequences

- Users may find that actions they could take previously are no longer available
  to them.
- Developers must be aware that some actions should be subject to authorisation
  controls, and develop new features accordingly.
