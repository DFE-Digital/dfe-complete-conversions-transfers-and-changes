# 21. Use a seperate database server instance

Date: 2023-10-18

## Status

Accepted

Supercedes [7. Use the Academies DB as the datastore](0007-use-the-academies-db-as-the-datastore.md)

## Context

The technical architecture of the programme requires the speration of the
product database instances, for performance and seperation of data.

## Decision

The product database will be hosted on a specific instance in the CIP tenant.

## Consequences

- infastructure will need to be created
- data migration will need to be carried out
- robust plan to continue to provide data to existing consumers will need to be
  in place
- the programme wide architecture will be more fragmented
- further security and 'health' checks may be required
- server load from other sources will no longer effect the Complete product
- Complete product data tables will be isolated from the other products
