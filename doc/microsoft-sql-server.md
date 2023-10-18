# Microsoft SQL Server

As per this [ADR](./0007-use-the-academies-db-as-the-datastore.md), the
application must store data in the 'Academies Database' which runs on Microsoft
SQL Server.

As this setup is relatively unconventional, this documentation may be of use.

## Setup

See the
[Setup Microsoft SQL Server](/doc/getting-started.md#setup-microsoft-sql-server)
in the getting started documentation for more information.

## Running the server

As SQL Server does not run natively on macOS we use the
[Azure SQL Edge](https://hub.docker.com/_/microsoft-azure-sql-edge) image. See
this [ADR](./decisions/0013-use-the-microsoft-azure-sql-edge-container-image.md)
for the reasons behind this choice.

The `script/server` script will create the appropriate containers for you.

See the [getting started](/doc/getting-started.md) and
[developer scripts](/doc/developer-scripts.md) documentation for more.

## Tooling

[Azure Data Studio](https://docs.microsoft.com/en-gb/sql/azure-data-studio/download-azure-data-studio?view=sql-server-ver16)
is a native application to connect to the local SQL server.

## SQL Server 'schemas'

In an unfortunate naming collision, the term 'schema' is used in SQL Server to
allow:

> ...for more flexibility in managing database object permissions.[1]

In production, the application only has access to a single schema (`complete`)
and creates all database tables within that schema.

Locally, the overhead of creating and maintaining the login, users, schemas and
permissions was felt to be to high and so we do not use a custom schema in our
development setup, creating tables in the default `dbo` schema.

[1](https://docs.microsoft.com/en-us/sql/relational-databases/security/authentication-access/ownership-and-user-schema-separation?view=sql-server-ver16)
