# 28. Set up Github Codespaces

Date: 2024-10-18

## Status

Accepted

## Context

We identified a need for the application to be run on Windows machines (most
developers currently use MacOS).

## Decision

After discussing various solutions it was decided that the least complex option
was to set the application up to run on Github Codespaces as required.

[Github Codespaces](https://github.com/features/codespaces) are virtual
environments that allow the application to be run in a hosted virtual machine on
Github. The codebase can also be edited via a virtual instance of VS Code (or
the developer may choose to use a bridge to their preferred IDE if available).

## Consequences

- The application can be run without the developer needing to install and
  configure Ruby, Node, Docker etc on their machine.
- The application codebase can be edited without an IDE on the developer's
  machine.
- The application can be more easily worked on by non-developers, e.g. Content
  desginers or UX, who may not have the resources available to run the
  application locally.
- The decision to use Github Codespaces has a financial cost implication, based
  on the amount of time a Codespace is being actively run.
