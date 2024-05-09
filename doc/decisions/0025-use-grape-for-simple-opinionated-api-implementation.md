# 25. Use Grape for simple opinionated Api implementation

Date: 2024-05-09

## Status

Accepted

## Context

We need to add an Api to the application. This is initially to allow projects to
be created via a POST request to an endpoint.

## Decision

Use the [Grape gem](https://github.com/ruby-grape/grape/) to add a simple,
opinionated Api to the application.

Authenticate users with an Api key, which is passed in an `Apikey` header in
requests.

## Consequences

Other applications will be able to interact with our application via the Api.
