# DfE: Complete conversions, transfers and changes

[![Continuous integration](https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/actions/workflows/continuous-integration.yml/badge.svg)](https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/actions/workflows/continuous-integration.yml)

## Getting started

This repository follows the
[Scripts To Rule Them All](https://github.com/dxw/tech-team-rfcs/blob/main/rfc-023-use-scripts-to-rule-them-all.md)
pattern. To get started with development (or to restore your environment to a
clean state):

1. Make sure you have [Homebrew](https://brew.sh/) installed
1. Run `script/setup`.

This will handle installing various dependencies, and run application setup
tasks.

### Add yourself as a user

The service will need to recognise you as a user, use the `users:create` task to
add your DfE email address.

```bash
bin/rails users:create EMAIL_ADDRESS=you@education.gov.uk
```

## Running a server

To start a local server, run `script/server`. Once started the application is
available at [`http://localhost:3000/`](http://localhost:3000/).

## Testing

To run the test suite, run `script/test`.

## Environment variables

See .env.example

## ADRs

You can find the [ADRs](https://adr.github.io/) for this project in the
[`doc/decisions`](https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/tree/develop/doc/decisions)
folder.
