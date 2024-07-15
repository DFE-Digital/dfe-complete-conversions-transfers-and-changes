# 26. Storing temporary data for stepped forms

Date: 2024-07-11

## Status

Accepted

## Context

Stepped forms or multi step forms are a common pattern in GOV.UK services.

The concept is that a user builds up the data in a given object over a series of
forms. Generally we do not want to create the objects in the database until all
steps are completed.

This leaves the issue of how to store the 'temporary' data before submission.

The session is a good place to store this data, but we have to use the cookie
store which has a hard 4kb limit which may not be suitable for forms that have
free text responses.

A good next best option is the cache store. This is abstracted by `Rails.cache`
and can be backed by various services.

## Decision

We'll use the Rails cache store and write our temporary values there.

The store will be backed by Redis as we already have a dependency on it.

We will use unique keys for the values in the store so that they do not clash,
the key should include a unique value for each user.

We will set a timeout on the values stored with a default of one hour, we should
handle the case when the values have expired.

## Consequences

- Complexity in the application increases
- dependent on Redis in ALL environments
