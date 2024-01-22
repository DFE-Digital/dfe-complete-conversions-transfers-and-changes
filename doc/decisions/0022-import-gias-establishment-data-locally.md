# 22. Import GIAS Establishment data locally

Date: 2024-01-22

## Status

Accepted

## Context

When schools convert to Academies, they receive a new URN from GIAS.

The Academies API contains academy data from GIAS. We have been consuming this
API to fetch academies data.

However, publicly, the Academies API only contains details of academies which
have opened. We have a requirement to show details for academies which have not
yet opened.

Only human users of GIAS with elevated rights on DfE Sign In can view the
details of academies which have not yet opened.

## Decision

To get around this restriction, we have decided to manually import the details
of Academies from GIAS into our application, as Gias::Establishment records. We
can then query these records for academy details. The data needs to be exported
from GIAS by someone with elevated access rights, then imported into our
application.

We can then query and display the academy data using these records, and not the
Academies API. We will therefore be able to show information for academies which
have not yet opened.

## Consequences

- The responsibility for keeping these records updated locally will be with
  service support
- Service support will need to regularly export data from GIAS and import it
  into the application via the UI
- We will be able to show details of academies which have not yet opened in the
  application, assuming the details have been imported by service support
