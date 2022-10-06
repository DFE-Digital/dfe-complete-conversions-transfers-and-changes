# Section filename Schema

```txt
uk.gov.education/rsd/cctc/tasklist#/properties/sections/items
```

The name (without the .yml extension) of the file which defines the section.

| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                        |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :------------------------------------------------------------------------------------------------ |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [tasklist.schema.json\*](../../app/workflows/schemas/tasklist.schema.json "open original schema") |

## items Type

`string` ([Section filename](tasklist-properties-list-of-sections-section-filename.md))

## items Constraints

**pattern**: the string must match the following regular expression:&#x20;

```regexp
^[a-z0-9-]+$
```

[try pattern](https://regexr.com/?expression=%5E%5Ba-z0-9-%5D%2B%24 "try regular expression with regexr.com")

## items Examples

```yaml
kickoff

```

```yaml
clear-legal-docs

```
