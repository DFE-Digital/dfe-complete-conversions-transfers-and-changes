[![Continuous integration](https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/actions/workflows/continuous-integration-tests.yml/badge.svg)](https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/actions/workflows/continuous-integration-tests.yml)

# DfE: Complete conversions, transfers and changes

As a digital service being developed in DfE we aim to follow the
[DfE Technical Guidance](https://technical-guidance.education.gov.uk/).

## Environments

- [development](https://s184d01-compcdnendpoint-duepa5hpd8djhacd.z01.azurefd.net)
- [test](https://s184t01-compcdnendpoint-gnfrfkdpamcncjdm.z01.azurefd.net)
- [production](https://s184p01-compcdnendpoint-brbkfbdmdqene3f0.z01.azurefd.net)

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

## Additional documentation

- [The workflow files](/doc/workflow-files.md)
- [User accounts](/doc/user-accounts.md)
- [Microsoft SQL Server](/doc/microsoft-sql-server.md)

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
