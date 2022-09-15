# Worklow files

## Introduction

We made the decision early on to define the task list that makes up the heart of
our user journey in YAML.

We believe this offers us many advantages over alternatives such as modelling
everything in Ruby:

- making changes is very quick
- content is all in one place
- new workflows, of which there are at least four to come can be added simply
- it forces us to keep a focus on delivering a simple end-to-end journey early
  on

We offset these against known disadvantages:

- disconnect between the Ruby code and business domain
- projects created after a workflow change are not updated (although this could
  be an advantage!)
- may not support additional complexity

Whilst the applicaiton and data it models remains relatively straight forward,
we are happy to continue to suppor the concpet of workflow files.

## Location

Workflow files are stored in `app/workflows`.

## Including Markdown in the workflow

To include Markdown while preserving newlines and whitespace we can use the
_literal style_. This is indicated by a pipe (`|`) character followed by
indented content. For example:

```yaml
guidance_text: |
  # A h1 title header

  ## Lists

  This is a list:

  * of multiple
  * things
  * and such
```
