# 7. Use the Academies DB as the datastore

Date: 2022-07-14

## Status

Superceded by [21. Use a seperate database server instance](0021-use-a-seperate-database-server-instance.md)

## Summary

We decided to use the shared Academies database as the datastore for the
Completions application rather than a separate PostgreSQL in order to keep all
RDD data in one place and avoid having to go through an assurance process,
accepting that this is a non-standard approach for a Rails application and will
require some extra work to validate fully in the short term and may be harder to
maintain in the long term.

## Context

Most applications being built in RDD store their data in a dedicated schema
within the shared Academies database (Microsoft SQL Server). The Completions
team are building a Ruby on Rails application, and proposed storing data in a
separate PostgreSQL database because this is the standard approach for Rails
applications and would enable them to iterate the design of their data models
more quickly. Concerns were raised that PostgreSQL is an untested technology
within RDD and would need an IT Health Check to provide assurance. Storing data
in a separate database may also cause problems for other applications such as
TRAMS which rely on the shared Academies database.

## Decision

The Completions app will not use a separate PostgreSQL database, and instead
will use the Academies database as their back end in line with the convention
followed by other RDD applications.

## Consequences

### Benefits

- No need for an IT Health Check that will cost money and cause a delay
- Follows the convention used elsewhere in RDD, making support easier
- Keeps all RDD data in one place, making integrations and reporting easier

### Challenges

- Is a non-standard approach for a Rails application, will require some extra
  work to validate fully, and may be harder to maintain in the long term
