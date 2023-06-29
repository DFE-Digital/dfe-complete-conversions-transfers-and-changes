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

To deploy a release to either `test` or `production` environments, go to GitHub
Actions for the repo, and select ['Deploy to Environment'](#) from the sidebar.

A button will be visible in the top right corner labelled 'Run workflow'.
Clicking this button will open a modal window where you will be prompted with
the following options:

- **Use workflow from:**
  - Select the dropdown, then click 'Tags' and select your 'release-x' tag.
- **Choose an environment to deploy to:**
  - Select 'test' or 'production' as appropriate

Clicking the 'Run workflow' button will kick-off a deployment with your
specified options.

The Docker image will be built, then pushed up to a container registry, and then
both Azure Container Apps (web app & worker) will be restarted with the latest
image.
