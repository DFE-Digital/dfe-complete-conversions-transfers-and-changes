# 23. Our Approach To Linting And Formatting

Date: 2024-05-02

## Status

Accepted

## Context

Our code should be approachable and consistent in it's style, we use linting and
formatting tools to achieve this with as little effort as possible.

## Decision

We will use the following tooling to maintain our style:

- Ruby > Standard: https://github.com/standardrb/standard
- ERB > ERB-Lint: https://github.com/Shopify/erb-lint
- JavaScript > Standard: https://github.com/standard/standard
- Markdown > Prettier: https://github.com/prettier/prettier

These tools will run in CI and we will not be able to merge work until these
pass.

When we started out the project used ESLint for JavaScript, we decided to change
to standard as it follows the same philosophy as the Ruby counter part:

- simple
- maintainable
- decisions already made

We are also changing or approach to what is linted and formatted, moving from an
'everything with exceptions' to a 'only the items we say' approach.

This speeds things up at the cost of having to add new items as they are
introduced.

## Consequences

- from this point on we will switch to Standard for JavaScript
- code will be consistent in style
- the burden on developers is acceptable
- CI will run all linting and formatting
- newly introduced areas of the code base may need to be included in linting or
  formatting
