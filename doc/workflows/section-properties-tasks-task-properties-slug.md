# Slug Schema

```txt
uk.gov.education/rsd/cctc/section#/properties/tasks/items/properties/slug
```

A unique human-readable string which identifies this task.

| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                      |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :---------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [section.schema.json\*](../../app/workflows/schemas/section.schema.json "open original schema") |

## slug Type

`string` ([Slug](section-properties-tasks-task-properties-slug.md))

## slug Constraints

**pattern**: the string must match the following regular expression:&#x20;

```regexp
^[a-z0-9-]+$
```

[try pattern](https://regexr.com/?expression=%5E%5Ba-z0-9-%5D%2B%24 "try regular expression with regexr.com")

## slug Examples

```yaml
handover-with-rdo

```

```yaml
clear-and-sign-church-supplemental-agreement

```
