# 16. Use single table inheritance for Projects

Date: 2023-02-06

## Status

Accepted

## Context

The concept of a project is a fundamental part of the real world process.

There are three types of project that the application must support in the long
term:

- A conversion
- A transfer
- A change

## Decision

As there is a large amount of shared attributes between project types, we will
use single table inheritance[1] to model all of them.

This allows the team to model the differences in code whilst keeping the number
of database tables to a minimum.

## Consequences

- the number of columns in the project table will go up with each attribute
  added
- some database columns will be redundant for some project types

[1]
https://guides.rubyonrails.org/association_basics.html#single-table-inheritance-sti
