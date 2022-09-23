# Section Schema

```txt
/schemas/section
```

A single section within a task list.

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                    |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :-------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Forbidden             | none                | [section.schema.json](../../app/workflows/schemas/section.schema.json "open original schema") |

## Section Type

`object` ([Section](section.md))

# Section Properties

| Property        | Type     | Required | Nullable       | Defined by                                                                  |
| :-------------- | :------- | :------- | :------------- | :-------------------------------------------------------------------------- |
| [title](#title) | `string` | Required | cannot be null | [Section](section-properties-title.md "/schemas/section#/properties/title") |
| [tasks](#tasks) | `array`  | Optional | cannot be null | [Section](section-properties-tasks.md "/schemas/section#/properties/tasks") |

## title



`title`

*   is required

*   Type: `string`

*   cannot be null

*   defined in: [Section](section-properties-title.md "/schemas/section#/properties/title")

### title Type

`string`

## tasks

A list of tasks within a section.

`tasks`

*   is optional

*   Type: `object[]` ([Task](section-properties-tasks-task.md))

*   cannot be null

*   defined in: [Section](section-properties-tasks.md "/schemas/section#/properties/tasks")

### tasks Type

`object[]` ([Task](section-properties-tasks-task.md))

### tasks Constraints

**minimum number of items**: the minimum number of items for this array is: `1`
