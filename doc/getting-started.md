# Getting started

## Codespaces

If you are not a developer, or you are using a Windows machine,
we recommend running this application using Github Codespaces.
See [Running with Codespaces](/doc/running-with-codespaces.md).

## Getting the basics

This is a Rails application, you will need access to:

- Ruby `.ruby-version`
- Node `.node-version`
- [Homebrew](https://brew.sh/)

Make sure you can run appropriate versions in you development environment.

- Run `script/initial_setup` to install dependencies

## Setup Microsoft SQL Server environment

As we run Microsoft SQL Server, we have to run it inside a container. To make
this as simple as we can we use docker compose to launch an appropriate
instance.

1. Duplicate `.env.database.example` as `.env.database` and set:

   ```
   ACCEPT_EULA=Y
   MSSQL_SA_PASSWORD=<database_password>
   ```

   Where `<database_password>` is at least 8 characters including uppercase,
   lowercase letters, base-10 digits and/or non-alphanumeric symbols, see the
   [image docs](https://hub.docker.com/_/microsoft-mssql-server).

   These are then used by the `docker-compose.database-only.yml` to launch and
   instance of SQL Server.

1. Create `.env.development.local` and `.env.test.local` and add:

   ```
   DATABASE_PASSWORD=<database_password>
   ```

   Where `<database_password>` is the same as in `.env.database`.

   The application will use these credentials to access the database and so must
   all be the same.

## Seeding the database

Read the [seeding the database documentation](/doc/seeding-the-database.md).

## Get the server running

With everything setup you can start the backing services and run the app with:

`script/server`

We have a bunch of devloper scripts to help day to day, see the
[scripts documentation](/doc/developer-scripts.md).
