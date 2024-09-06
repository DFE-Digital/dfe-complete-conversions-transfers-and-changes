# 18. Use Members API to retrieve MP's details

Date: 2023-04-20

## Status

Superceded by
[27. Use the Persons API to fetch MP details](0027-use-the-persons-api-to-fetch-mp-details.md)

## Context

The Member of Parliament for the constituency a school is in needs to be
informed that the school is becoming an academy. They will be informed via
letter. The caseworkers using the application need to be able to find the name
of the MP associated with the school, their email address and physical address.

## Decision

We will use the Parliamentary Members API to retrieve details for the MP
associated with a school's parliamentary constituency.

We already use the Academies API to retrieve a school's information, which
includes its parliamentary constituency name.

We can use the parliamentary constituency name to query the Members API and find
the constituency data, include the Member of Parliament's ID.

We then take the MP's ID and use that to find the member's name and address
details (retrieved in two separate calls).

The Parliamentary Members API is publicly accessible at
https://members-api.parliament.uk/

## Consequences

### Benefits

- The MP details will not be stored in the application.
- There is no need for the MP details to be entered into the application, and
  edited should the MP for a parliamentary constituency change.

### Challenges

- Each time an MP's details are requested, the application makes 3 calls to the
  Members API. This has a performance impact on the application, but it is
  acceptable because the MP's details page will not be accessed regularly.
