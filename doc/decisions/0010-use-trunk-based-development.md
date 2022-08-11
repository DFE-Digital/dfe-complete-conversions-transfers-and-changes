# 10. Use Trunk Based Development

Date: 2022-08-03

## Status

Accepted

## Context

At present, the application is developed primarily on the `develop` git branch.
Features branches are made from this, reviewed and then merged. At release time,
`develop` is merged into `main`.

Maintaining a separate `develop` branch introduces complexity into releasing new
versions, without introducing any significant benefit. For example, it can lead
to new features being merged during the release process and inadvertently being
included in the release.

To simplify things, we should move to a single `main` branch which feature
branches are made from, reviewed and merged to. At release time, new releases
are introduced by tagging a known point in the `main` branch as a new release.

This provides a better fit for a more rapid release cadence, which in turn is a
better fit for the rapid iteration of the product during the private beta phase.

## Decision

This application will be developed broadly in line with the
[Trunk Based Development](https://trunkbaseddevelopment.com/) pattern, and
releases will be done by
[releasing from trunk](https://trunkbaseddevelopment.com/release-from-trunk/).

## Consequences

- The `develop` branch must be merged into `main`.
- Future merges must be made to `main` instead of `develop` (and GitHub should
  have its default branch configuration updated to match).
- The release process and documentation must be modified to account for this
  change.
