# 17. Use delegated types for task lists

Date: 2023-02-06

## Status

Accepted

## Context

Along with projects, task lists are a fundamental real world process that we
must model in the application.

Task lists store the actions users must perform and the data that users must
provide to complete the journey.

## Decision

The team spiked and discussed many approaches to model the task list in the
application.

We settled on a relatively new feature of Rails, delegated types[1] which allow
us to break down task lists into task objects that share a single database
table.

This encapsulates an entire task list in one table, whilst allowing us to
manipulate each task individually in all layers of the application code.

## Consequences

- much of the implementation will follow the Rails doctrine of convention over
  configuration[2]
- there is some risk in using newer features as developers may not be familiar
  with them
- splitting tasks list models and the tasks that make them up will mean that the
  number of files across the model, view and controller layer will be high

[1]
https://api.rubyonrails.org/classes/ActiveRecord/DelegatedType.html#method-i-delegated_type
[2] https://rubyonrails.org/doctrine#convention-over-configuration
