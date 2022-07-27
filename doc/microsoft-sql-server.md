# Microsoft SQL Server

As per this [ADR](./0007-use-the-academies-db-as-the-datastore.md), the
application must store data in the 'Academies Database' which runs on Microsoft
SQL Server.

As this setup is relatively unconventional, this documentation may be of use.

## Setup

See the [Setup Microsoft SQL Server](../README.md#setup-microsoft-sql-server) in
the readme for more information.

## Running the server

As SQL Server does not run natively on macOS we use the
[official Docker image](https://hub.docker.com/_/microsoft-mssql-server).

If you use the scripts to rule them all pattern, the container will be started
for you, but bear in mind, it may not be stopped for you.

To run the container manually:

```bash
docker-compose -f docker-compose.database.local.yml up -d
```

And to stop the container:

```bash
docker-compose -f docker-compose.database.local.yml down
```

## Tooling

[Azure Data Studio](https://docs.microsoft.com/en-gb/sql/azure-data-studio/download-azure-data-studio?view=sql-server-ver16)
is a native application to connect to the local SQL server.

## SQL Server 'schemas'

In an unfortunate naming collision, the term 'schema' is used in SQL Server to
allow:

> ...for more flexibility in managing database object permissions.[1]

In production, the application only has access to a single schema and creates
all database tables within that schema.

Locally, the overhead of creating and maintaining the login, users, schemas and
permissions was felt to be to high and so we do not use a custom schema in our
development setup, creating tables in the default `dbo` schema. More detail on
this decision is in this
[ADR](./decisions/0007-use-the-academies-db-as-the-datastore.md).

[1](https://docs.microsoft.com/en-us/sql/relational-databases/security/authentication-access/ownership-and-user-schema-separation?view=sql-server-ver16)
