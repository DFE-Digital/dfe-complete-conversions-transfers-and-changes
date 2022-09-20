# Task Schema

```txt
uk.gov.education/rsd/cctc/section#/properties/tasks/items
```

A task on the task list, which contains one or more actions.

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                      |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :---------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Forbidden             | none                | [section.schema.json\*](../../app/workflows/schemas/section.schema.json "open original schema") |

## items Type

`object` ([Task](section-properties-tasks-task.md))

# items Properties

| Property                               | Type      | Required | Nullable       | Defined by                                                                                                                                                      |
| :------------------------------------- | :-------- | :------- | :------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [title](#title)                        | `string`  | Required | cannot be null | [Section](section-properties-tasks-task-properties-title.md "uk.gov.education/rsd/cctc/section#/properties/tasks/items/properties/title")                       |
| [hint](#hint)                          | `string`  | Optional | cannot be null | [Section](section-properties-tasks-task-properties-hint.md "uk.gov.education/rsd/cctc/section#/properties/tasks/items/properties/hint")                         |
| [guidance\_summary](#guidance_summary) | `string`  | Optional | cannot be null | [Section](section-properties-tasks-task-properties-guidance_summary.md "uk.gov.education/rsd/cctc/section#/properties/tasks/items/properties/guidance_summary") |
| [guidance\_text](#guidance_text)       | `string`  | Optional | cannot be null | [Section](section-properties-tasks-task-properties-guidance_text.md "uk.gov.education/rsd/cctc/section#/properties/tasks/items/properties/guidance_text")       |
| [optional](#optional)                  | `boolean` | Optional | cannot be null | [Section](section-properties-tasks-task-properties-optional.md "uk.gov.education/rsd/cctc/section#/properties/tasks/items/properties/optional")                 |
| [actions](#actions)                    | `array`   | Required | cannot be null | [Section](section-properties-tasks-task-properties-actions.md "uk.gov.education/rsd/cctc/section#/properties/tasks/items/properties/actions")                   |

## title



`title`

*   is required

*   Type: `string`

*   cannot be null

*   defined in: [Section](section-properties-tasks-task-properties-title.md "uk.gov.education/rsd/cctc/section#/properties/tasks/items/properties/title")

### title Type

`string`

## hint



`hint`

*   is optional

*   Type: `string`

*   cannot be null

*   defined in: [Section](section-properties-tasks-task-properties-hint.md "uk.gov.education/rsd/cctc/section#/properties/tasks/items/properties/hint")

### hint Type

`string`

## guidance\_summary



`guidance_summary`

*   is optional

*   Type: `string`

*   cannot be null

*   defined in: [Section](section-properties-tasks-task-properties-guidance_summary.md "uk.gov.education/rsd/cctc/section#/properties/tasks/items/properties/guidance_summary")

### guidance\_summary Type

`string`

## guidance\_text



`guidance_text`

*   is optional

*   Type: `string`

*   cannot be null

*   defined in: [Section](section-properties-tasks-task-properties-guidance_text.md "uk.gov.education/rsd/cctc/section#/properties/tasks/items/properties/guidance_text")

### guidance\_text Type

`string`

## optional



`optional`

*   is optional

*   Type: `boolean`

*   cannot be null

*   defined in: [Section](section-properties-tasks-task-properties-optional.md "uk.gov.education/rsd/cctc/section#/properties/tasks/items/properties/optional")

### optional Type

`boolean`

## actions

A list of actions which collectively make up a task.

`actions`

*   is required

*   Type: `object[]` ([Action](section-properties-tasks-task-properties-actions-action.md))

*   cannot be null

*   defined in: [Section](section-properties-tasks-task-properties-actions.md "uk.gov.education/rsd/cctc/section#/properties/tasks/items/properties/actions")

### actions Type

`object[]` ([Action](section-properties-tasks-task-properties-actions-action.md))
