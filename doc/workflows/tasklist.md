# Task list Schema

```txt
uk.gov.education/rsd/cctc/tasklist
```

A top-level definition of a task list.

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                      |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :---------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Forbidden             | none                | [tasklist.schema.json](../../app/workflows/schemas/tasklist.schema.json "open original schema") |

## Task list Type

`object` ([Task list](tasklist.md))

# Task list Properties

| Property              | Type    | Required | Nullable       | Defined by                                                                                                     |
| :-------------------- | :------ | :------- | :------------- | :------------------------------------------------------------------------------------------------------------- |
| [sections](#sections) | `array` | Optional | cannot be null | [Task list](tasklist-properties-list-of-sections.md "uk.gov.education/rsd/cctc/tasklist#/properties/sections") |

## sections

A list of names of section definition files, in the order they should appear.

`sections`

*   is optional

*   Type: `string[]`

*   cannot be null

*   defined in: [Task list](tasklist-properties-list-of-sections.md "uk.gov.education/rsd/cctc/tasklist#/properties/sections")

### sections Type

`string[]`

### sections Constraints

**minimum number of items**: the minimum number of items for this array is: `1`
