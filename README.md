[![Continuous integration](https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/actions/workflows/continuous-integration-tests.yml/badge.svg)](https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/actions/workflows/continuous-integration-tests.yml)

# DfE: Complete conversions, transfers and changes

As a digital service being developed in DfE we aim to follow the
[DfE Technical Guidance](https://technical-guidance.education.gov.uk/).

## Environments

- [development](https://dev.complete.education.gov.uk)
- [test](https://test.complete.education.gov.uk)
- [production](https://complete.education.gov.uk)

Console and logs can be accessed on all three environments, details are in
[accessing console and logs](/doc/console-and-logs.md)

## Errors and monitoring

We use
[sentry.io](https://sentry.io/organizations/sdd-n7/projects/complete-conversions-transfers-and-changes/?project=6684508)
to monitor errors and the performance of the application.

## Architecture decision records

You can find the ADRs for this project in [doc/decisions](/doc/decisions).

## Shared components and patterns

- [DfE GOV.UK Components](https://govuk-components.netlify.app/)
- [DfE GOV.UK Form Builder](https://govuk-form-builder.netlify.app/)
- [GOV.UK Frontend](https://github.com/alphagov/govuk-frontend)
- [GOV.UK Accessible autocomplete](https://github.com/alphagov/accessible-autocomplete)
- [MOJ Frontend](https://github.com/ministryofjustice/moj-frontend)
- [dxw Mail Notify](https://github.com/dxw/mail-notify)

## Getting started

If this is your first time running the application, see the
[`getting started documentation`](/doc/getting-started.md) for instructions.

## In-depth documentation

- [User accounts](/doc/user-accounts.md)
- [Task lists and tasks](/doc/task-lists-and-tasks.md)
- [API Consumption](/doc/api-consumption.md)
- [Microsoft SQL Server](/doc/microsoft-sql-server.md)
- [Automated accessibility checks](/doc/accessibility-tests.md)
- [Console and logs in live environments](/doc/console-and-logs.md)
- [Releases and deployments](/doc/releases-and-deploys.md)
- [Environment variables](/doc/environment-variables.md)
- [Infrastructure and Terraform](/doc/infrastructure-and-terraform.md)
