# Getting started

## Getting the basics

These instructions apply to macOS.

1. Make sure you have [Homebrew](https://brew.sh/) installed
1. Run `brew bundle install --verbose --no-lock` to install system-level
   dependencies

## Setup Microsoft SQL Server

As we run Microsoft SQL Server, we have to run it inside a container. To make
this as simple as we can we use docker-compose to launch an appropriate
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

## Setup everything else

This repository follows the
[Scripts To Rule Them All](https://github.com/dxw/tech-team-rfcs/blob/main/rfc-023-use-scripts-to-rule-them-all.md)
pattern. To get started with development (or to restore your environment to a
clean state):

1. Run `script/setup`.

This will handle installing various dependencies, and run application setup
tasks.

## Add yourself as a user

[See 'Creating a new user'](/doc/users-accounts.md#creating-a-new-user)

## Running a server

To start a local server, run `script/server`. Once started the application is
available at [`http://localhost:3000/`](http://localhost:3000/).

## Testing

To run the test suite, run `script/test`.

### Reducing test scope

You can optionally use `ONLY_LINTING` and `ONLY_APP_TESTS` environment variables
to selectively run either linting/formatting/schema tests or application tests
respectively, for example

```bash
ONLY_LINTING=1 script/test
```

### Fixing formatting

By default, linters will cause a test failure if there are formatting problems.
However, you can automatically fix formatting in many cases by using the
`AUTO_FIX_FORMATTING` environment variable:

```bash
AUTO_FIX_FORMATTING=1 script/test
```

This can also be combined with the reduced scopes for fast formatting fixes, for
example:

```bash
AUTO_FIX_FORMATTING=1 ONLY_LINTING=1 script/test
```

### Running accessibility tests

To run accessibility tests locally, see the
[accessibility tests documenation](/doc/accessibility-tests.md) for details.
