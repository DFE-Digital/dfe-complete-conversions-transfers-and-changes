# 9. Use sequential numbering for release versions

Date: 2022-07-28

## Status

Accepted

## Context

As part of implementing a process for releasing versions of the software, we
need to decide how each version should be numbered. There are various options
for this, including [Semantic Versioning](https://semver.org/), or simple
sequential version numbering.

The application is being built in an iterative manner, which means that it is
likely we will be frequently releasing small changes. If we were using Semantic
Versioning, this could lead to a rapid increase in version numbers which could
imply more significant changes to functionality than have actually taken place.

## Decision

Each release version is numbered sequentially from the previous.

## Consequences

There is no need to consider as part of the release process if a version
implements a breaking change or represents new functionality.
