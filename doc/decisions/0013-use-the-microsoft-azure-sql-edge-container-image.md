# 13. Use the Microsoft Azure SQL Edge container image

Date: 2022-10-10

## Status

Accepted

## Context

Our application connects to a Microsoft SQL server database. In order to run
local development environments, our developers also need to run this product.

Some of the development team use ARM based Macs and the official Microsoft
container image for MSSQL server [1] is not built for this architecture.

Whilst we wait for this issue to be fixed, our only alternative is to use a
different product offering container image, 'Azure SQL Edge' - this image
contains a running MSSQL server amoungst other things, and can be used as a
replacement.

Azure SQL Edge does not have complete feature parity with MSSQL server [2], we
believe it has enough features for our use case.

## Decision

We will switch all our Containers to use the Azure SQL Edge image.

## Consequences

- our local development environments are not running the same product as our
  live environments.
- we need to keep in mind that there may be limits on the features found in the
  Azure SQL Edge image when running locally.
- once the MSSQL server image is built, we will have to switch back.

[1] https://hub.docker.com/_/microsoft-mssql-server?tab=description [2]
https://learn.microsoft.com/en-us/azure/azure-sql-edge/features?source=recommendations
