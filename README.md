[![CI Checks](https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/actions/workflows/ci-checks.yml/badge.svg)](https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/actions/workflows/ci-checks.yml)

# DfE: Complete conversions, transfers and changes

As a digital service being developed in DfE we aim to follow the
[DfE Technical Guidance](https://technical-guidance.education.gov.uk/).

## Environments

- [development](https://dev.complete.education.gov.uk)
- [test](https://test.complete.education.gov.uk)
- [production](https://complete.education.gov.uk)

Console and logs can be accessed on all three environments, details are in
[accessing console and logs](/doc/console-and-logs.md)

## Getting started

If this is your first time running the application, see the
[`getting started documentation`](/doc/getting-started.md) for instructions.

## Day to day development

There are [developer scripts](/doc/developer-scripts.md) to make working on the
code straight forward for those that would like to use them.

## In-depth documentation

- [Seeding the database](/doc/seeding-the-database.md)
- [User accounts](/doc/user-accounts.md)
- [Task lists and tasks](/doc/task-lists-and-tasks.md)
- [Importing GIAS data](/doc/import-gias-data.md)
- [Event logging](/doc/event-logging.md)
- [API Provision](/doc/api.md)
- [API Consumption](/doc/api-consumption.md)
- [Microsoft SQL Server](/doc/microsoft-sql-server.md)
- [Automated accessibility checks](/doc/accessibility-tests.md)
- [Console and logs in live environments](/doc/console-and-logs.md)
- [Releases and deployments](/doc/releases-and-deploys.md)
- [Environment variables](/doc/environment-variables.md)
- [Infrastructure and Terraform](/doc/infrastructure-and-terraform.md)
- [Developer scripts](/doc/developer-scripts.md)
- [GOV.UK Notify](/doc/govuk-notify.md)
- [Information banner](/doc/information-banner.md)
- [Redis](/doc/redis.md)
- [Running with Docker (local dev)](/doc/running-with-docker.md)

## Errors and monitoring

All environments can be monitored in Azure application insights, each
environment has a dashboard:

- [development dashboard](https://portal.azure.com/#@platform.education.gov.uk/dashboard/arm/subscriptions/1d692707-6019-4f8c-b337-ec8cad61f998/resourcegroups/s184d01-comp/providers/microsoft.portal/dashboards/45d817c7-d715-4872-b976-c6b6fef76f04-dashboard)
- [test dashboard](https://portal.azure.com/#@platform.education.gov.uk/dashboard/arm/subscriptions/8e6b3792-ae2c-4424-9815-19d6a77b0600/resourcegroups/s184t01-comp/providers/microsoft.portal/dashboards/5918b480-2d54-4540-94c8-bfd73dc3befe-dashboard)
- [production dashboard](https://portal.azure.com/#@platform.education.gov.uk/dashboard/arm/subscriptions/e8bc9314-d27f-403a-bbe0-6b189d2efad2/resourcegroups/s184p01-comp/providers/microsoft.portal/dashboards/b473541d-3b3b-45d5-b025-97974730e369-dashboard)

## Architecture decision records

You can find the ADRs for this project in [doc/decisions](/doc/decisions).

## Shared components and patterns

- [DfE GOV.UK Components](https://govuk-components.netlify.app/)
- [DfE GOV.UK Form Builder](https://govuk-form-builder.netlify.app/)
- [GOV.UK Accessible autocomplete](https://github.com/alphagov/accessible-autocomplete)
- [dxw Mail Notify](https://github.com/dxw/mail-notify)
- [GOV.UK Frontend](https://github.com/alphagov/govuk-frontend)
- [MOJ Frontend](https://github.com/ministryofjustice/moj-frontend)
- [DfE Frontend](https://design.education.gov.uk/design-system/dfe-frontend)
