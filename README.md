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

## ADRs

You can find the [ADRs](https://adr.github.io/) for this project in the
[`doc/decisions`](/doc/decisions) folder.
