# 8. Variance between local and production environments

Date: 2022-07-27

## Status

Accepted

## Context

The application will connect to a Microsoft SQL server to store data. This
presents a number of challenges in setting up a local development environment
with complete parity to production.

In production the application connects with the credentials of a database user
who can only access the tables inside a 'schema', this guarantees the integrity
of the wider database.

Locally Rails assumes it can drop databases at will, this is difficult to
replicate along with the login, database user and permissions to exactly mirror
production.

For example the users in production must never drop the database, as it contains
schemas from other applications, locally the test database is routinely dropped
to clear it.

## Decision

We will use MS SQL Server locally but forego the same schema and user
restrictions as in production. We can use the per environment configuration to
ensure production is setup as expected.

## Consequences

We usually seek parity between our local and production environments and whilst
there is risk in this variance, it is far better to have a fast and efficient
developer experience.
