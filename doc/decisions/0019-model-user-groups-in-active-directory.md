# 19. Model user groups in Active Directory

Date: 2023-06-14

## Status

Accepted

## Context

The application models various user roles for authorisation. The roles represent
real world groups of end users.

Currently the delivery team must manually add users and their role to the
application.

## Decision

Model the user groups in the DfE T1 Active Directory. New groups will be created
so that the ownership and result of being in a group is explicit, rather than
relying on existing groups in the directory.

Roles will be mapped to the local user record in the application database when a
user session is created. This will allow the application to stay in sync with
the directory whilst retaining users as a data used long term in the
application.

## Consequences

- syncronisation between the directory and local application database
- increasing the number of groups in the directory
- adding to the support cost of the application
- process to on-board users to the correct groups documented and maintained
