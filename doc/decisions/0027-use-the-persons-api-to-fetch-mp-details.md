# 27. Use the Persons API to fetch MP details

Date: 2024-09-06

## Status

Accepted

Supercedes
[18. Use Members API to retrieve MP's details](0018-use-parliamentary-members-api.md)

## Context

We previously used the Parliamentary Digital Services Members API to fetch MP
details.

Unfortunately we found the API to be non-performant, and when exporting reports
with multiple projects we were rate-limited when trying to fetch MP details for
the project.

## Decision

The DfE Common Architecture Team are building a Persons API to return important
people associated with an establishment. One of the people they will be
returning is the MP for a constituency. We can use an establishment's
constituency to get the MP details for a project.

## Consequences

- We are no longer reliant on an external API for MP details
- MP details are available in exports and as an External Contact for a project
