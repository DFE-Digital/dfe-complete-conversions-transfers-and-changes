# Accessibility tests

To help catch any potential accessibility violations, we have a series of
automated accessibility tests. We use an accessibility tool `axe-core-rspec` for
these checks. These tests run within CI under job `Accessibility checks`.

## Set up

Before you can run the accessibility tests locally, you will need to ensure
Selenuim is set up properly. To do this, you will need to download
[geckodriver](https://github.com/mozilla/geckodriver) and have Firefox installed
on your machine.

## Running accessibility test locally

To run these tests locally, run
`bundle exec rspec --tag accessibility spec/accessibility`
