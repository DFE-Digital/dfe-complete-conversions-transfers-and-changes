[![Continuous integration](https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/actions/workflows/continuous-integration-rails.yml/badge.svg)](https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/actions/workflows/continuous-integration-rails.yml)

# DfE: Complete conversions, transfers and changes

As a digital service being developed in DfE we aim to follow the
[DfE Technical Guidance](https://technical-guidance.education.gov.uk/).

## Shared components and patterns

- [DfE GOV.UK Components](https://govuk-components.netlify.app/)
- [DfE GOV.UK Form Builder](https://govuk-form-builder.netlify.app/)
- [GOV.UK Frontend](https://github.com/alphagov/govuk-frontend)
- [GOV.UK Accessible autocomplete](https://github.com/alphagov/accessible-autocomplete)
- [MOJ Frontend](https://github.com/ministryofjustice/moj-frontend)

## Getting started

If this is your first time running the application, see the
[`getting started documentation`](/doc/getting-started.md) for instructions.

## Additional documentation

- [The workflow files](/doc/workflow-files.md)
- [User accounts](/doc/user-accounts.md)
- [Microsoft SQL Server](/doc/microsoft-sql-server.md)

## Running a server

To start a local server, run `script/server`. Once started the application is
available at [`http://localhost:3000/`](http://localhost:3000/).

## Testing

To run the test suite, run `script/test`.

## Environment variables

See [.env.example](./.env.example)

For production environments,
[additional variables are required](./doc/environment-variables.md)

## Releases and deployments

See [releases and deployments](./doc/releases-and-deploys.md)

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
