# Releases and deployments

## Introduction

We have three environments we can deploy to, all hosted on
[DfE CIP Azure tenant](https://docs.platform.education.gov.uk/index.html):

- development
- test
- production

We have separate release and deployments so that we can have fine grained
control of what code is deployed where.

The `development` environment tracks the `main` branch, with the other
environments have specific releases base on tags.

## Releases

Changes are together in a sequentially numbered release that can then be
deployed to one of our environments.

We should aim to create a new release at least once per sprint, but we have the
flexibility to release as often as needed.

### Creating a release

- create a new branch off `main` called `release-x` where `x` is the next
  release number in the sequence.

  You can check the releases in
  [GitHub](https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/tags)
  or locally with `git fetch --tags & git tag`.

- Update the `CHANGELOG.md`: add a release-x heading under the unreleased
  heading and update the links at the bottom of the file.
- Commit this change with `git commit -m "release-x"`.
- Push this branch and open a PR.
- You can use the
  [release checklist](https://raw.githubusercontent.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/main/.github/PULL_REQUEST_TEMPLATE/release.md)
  as the PR message and to ensure all steps are completed.
- Get this PR reviewed and approved, once approved, merge into the `main`
  branch.
- Tag the merge commit with `release-x` with
  `git fetch & git tag release-x commit-sha` where `commit-sha` is the SHA of
  the merge commit.
- Push the tag with `git push --tags`
- Create a new
  [Release in GitHub](https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/releases/new),
  reference the release tag and paste in the changes from `CHANGELOG.md`
  included in the release.

We have a [template](https://trello.com/c/8enGdMyy) to track releases on our
Trello board.

## Deployments

A deployment applies the changes in a release to an environment with the
exception of the `development`, which instead simply tracks the `main` branch.

We should aim to deploy to `production` at least once per sprint, we have the
flexibility to deploy as often as needed.

### Deploying

To deploy a release to either `testing` or `production` update the relevant
GitHub action to a specific release:

- [build-and-push-image-test.yml](https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/blob/main/.github/workflows/build-and-push-image-test.yml)
- [build-and-push-image-production.yml]()

- Create a new branch off of `main` called `deploy-release-{x}-to-{environment}`
  where `x` is the release number and `environment` is either `test` or
  `production`.
- Update the workflow file by changing the `release-x` value around line 16.
- Commit the change with the branch name as the commit message.
- Push the branch and open a PR, use the branch name as the PR message.
- Get the PR reviewed and approved, once approved, merge into the `main` branch.
- Open the [Azure portal](https://azure.microsoft.com)
- Locate the `Container app` in the correct environment (either `test` or
  `production`), the container app names are very similar, verify you have the
  correct one!
- Locate the `Revision management` and click on the provisioned version
- In the `Revision details` click `Restart`
