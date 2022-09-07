# DfE: Complete conversions, transfers and changes

[![Continuous integration](https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/actions/workflows/continuous-integration.yml/badge.svg)](https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/actions/workflows/continuous-integration.yml)

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

## Including Markdown in the workflow

We define task list workflows in YAML. To include Markdown while preserving
newlines and whitespace we can use the _literal style_. This is indicated by a
pipe (`|`) character followed by indented content. For example:

```yaml
guidance_text: |
  # A h1 title header

  ## Lists

  This is a list:

  * of multiple
  * things
  * and such
```

## Importing users in bulk

We can import users in bulk from a CSV file.

To use the `users:import` task, run:

```bash
bin/rails users:import CSV_PATH="<path relative to the project root>"
```

The headers of the CSV must be consistent with the attributes on the `user`
model. Boolean values can be indicated by `0` and `1`, all values should be
provided to avoid not-null constraint errors. For example:

| email                     | first_name | last_name | team_leader | regional_delivery_officer |
| ------------------------- | ---------- | --------- | ----------- | ------------------------- |
| john.doe@education.gov.uk | John       | Doe       | 1           | 0                         |
| jane.doe@education.gov.uk | Jane       | Doe       | 0           | 1                         |

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
