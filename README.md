# DfE: Complete conversions, transfers and changes

[![Continuous integration](https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/actions/workflows/continuous-integration-rails.yml/badge.svg)](https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/actions/workflows/continuous-integration-rails.yml)

## Getting started

If this is your first time running the application, see the
[`getting started documentation`](/doc/getting-started.md) for instructions.

## Running a server

To start a local server, run `script/server`. Once started the application is
available at [`http://localhost:3000/`](http://localhost:3000/).

## Testing

To run the test suite, run `script/test`.

## Environment variables

See .env.example

## Release process

Use the [release process template in Trello](https://trello.com/c/8enGdMyy) to
start a new release.



## ADRs

You can find the [ADRs](https://adr.github.io/) for this project in the
[`doc/decisions`](/doc/decisions) folder.

## Errors and monitoring

We use
[sentry.io](https://sentry.io/organizations/sdd-n7/projects/complete-conversions-transfers-and-changes/?project=6684508)
to monitor errors and the performance of the application.

## Infrastructure

We use infrastructure as code ([Terraform](https://www.terraform.io/)) to deploy
and manage resources hosting the app. This is stored in the `terraform`
directory.

Documentation: [terraform/README.md](/terraform/README.md)

## Documentation

- [The workflow files](doc/workflow.md)
- [User accounts](doc/user-accounts.md)
