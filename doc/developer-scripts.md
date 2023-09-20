# Developer scripts

We have a bunch of scripts to help day-to-day:

## Running a server

You want to start a local server and required backing services.

`script/server`

Once started the application is available at
[`http://localhost:3000/`](http://localhost:3000/).

## Running the entire test suite

The aim here is to replicate all tests that happen in CI so you can be confident
to ship, this is mostly a wrapper for the scripts documented later here.

`script/check_all`

## Running specs and coverage

You only want to run the Rspec specs and Simplecov coverage.

`script/specs`

If you supply a path to the script it will skip the coverage and only run those
specs, like this:

`scripts/specs specs/models`

As any subset of specs will not reach the required coverage.

## Running the linters

You want to only check formatting

`script/lint_and_format`

### Auto fixing option

You can set `AUTO_FIX=true` which will run any linting in auto fix any time as
an alternative to the `script/fix` shortcut.

## Auto fixing with linters

You want the linters to fix any errors, you will need to manage the changes.

`script/fix`

## Running the accessibility checks

See [accessibility tests documentation](/doc/accessibility-tests.md) for
details.

`script/check_accessibility`

## Running the code analysis

Run [Brakeman](https://brakemanscanner.org/).

`script/static_analysis`

## Start the backing services

Start just the backing services (MS SQL Server and Redis).

`script/start_backing_services`

## Stop the backing services

You want to stop the backing services (MS SQL Server and Redis) running after
starting them or running the application.

`script/stop_backing_services`
