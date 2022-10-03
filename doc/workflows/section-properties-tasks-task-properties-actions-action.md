# Action Schema

```txt
uk.gov.education/rsd/cctc/section#/properties/tasks/items/properties/actions/items
```

A single action which can be taken within a task.

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                      |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :---------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Forbidden             | none                | [section.schema.json\*](../../app/workflows/schemas/section.schema.json "open original schema") |

## items Type

`object` ([Action](section-properties-tasks-task-properties-actions-action.md))

## items Examples

```yaml
title: Check document validity
hint: Check that sections A, B and C are completed.
guidance_summary: What to check?
guidance_text: You can find [a list of what to check online](https://example.com).

```

```yaml
type: subheading
title: Signing by the Secretary of State

```

# items Properties

| Property                               | Type     | Required | Nullable       | Defined by                                                                                                                                                                                                         |
| :------------------------------------- | :------- | :------- | :------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [type](#type)                          | `string` | Optional | cannot be null | [Section](section-properties-tasks-task-properties-actions-action-properties-action-type.md "uk.gov.education/rsd/cctc/section#/properties/tasks/items/properties/actions/items/properties/type")                  |
| [title](#title)                        | `string` | Required | cannot be null | [Section](section-properties-tasks-task-properties-actions-action-properties-title.md "uk.gov.education/rsd/cctc/section#/properties/tasks/items/properties/actions/items/properties/title")                       |
| [hint](#hint)                          | `string` | Optional | cannot be null | [Section](section-properties-tasks-task-properties-actions-action-properties-hint.md "uk.gov.education/rsd/cctc/section#/properties/tasks/items/properties/actions/items/properties/hint")                         |
| [guidance\_summary](#guidance_summary) | `string` | Optional | cannot be null | [Section](section-properties-tasks-task-properties-actions-action-properties-guidance-summary.md "uk.gov.education/rsd/cctc/section#/properties/tasks/items/properties/actions/items/properties/guidance_summary") |
| [guidance\_text](#guidance_text)       | `string` | Optional | cannot be null | [Section](section-properties-tasks-task-properties-actions-action-properties-guidance-text.md "uk.gov.education/rsd/cctc/section#/properties/tasks/items/properties/actions/items/properties/guidance_text")       |

## type

The type of action which the user will be shown.

`type`

*   is optional

*   Type: `string` ([Action type](section-properties-tasks-task-properties-actions-action-properties-action-type.md))

*   cannot be null

*   defined in: [Section](section-properties-tasks-task-properties-actions-action-properties-action-type.md "uk.gov.education/rsd/cctc/section#/properties/tasks/items/properties/actions/items/properties/type")

### type Type

`string` ([Action type](section-properties-tasks-task-properties-actions-action-properties-action-type.md))

### type Constraints

**enum**: the value of this property must be equal to one of the following values:

| Value               | Explanation |
| :------------------ | :---------- |
| `"single-checkbox"` |             |
| `"subheading"`      |             |

### type Default Value

The default value is:

```json
"single-checkbox"
```

## title



`title`

*   is required

*   Type: `string` ([Title](section-properties-tasks-task-properties-actions-action-properties-title.md))

*   cannot be null

*   defined in: [Section](section-properties-tasks-task-properties-actions-action-properties-title.md "uk.gov.education/rsd/cctc/section#/properties/tasks/items/properties/actions/items/properties/title")

### title Type

`string` ([Title](section-properties-tasks-task-properties-actions-action-properties-title.md))

## hint

A short hint to explain to users how to complete the action.

`hint`

*   is optional

*   Type: `string` ([Hint](section-properties-tasks-task-properties-actions-action-properties-hint.md))

*   cannot be null

*   defined in: [Section](section-properties-tasks-task-properties-actions-action-properties-hint.md "uk.gov.education/rsd/cctc/section#/properties/tasks/items/properties/actions/items/properties/hint")

### hint Type

`string` ([Hint](section-properties-tasks-task-properties-actions-action-properties-hint.md))

## guidance\_summary

A summary of the guidance available when the user expands the guidance section.

`guidance_summary`

*   is optional

*   Type: `string` ([Guidance summary](section-properties-tasks-task-properties-actions-action-properties-guidance-summary.md))

*   cannot be null

*   defined in: [Section](section-properties-tasks-task-properties-actions-action-properties-guidance-summary.md "uk.gov.education/rsd/cctc/section#/properties/tasks/items/properties/actions/items/properties/guidance_summary")

### guidance\_summary Type

`string` ([Guidance summary](section-properties-tasks-task-properties-actions-action-properties-guidance-summary.md))

## guidance\_text

The text to include within the guidance drop-down section for this action.

`guidance_text`

*   is optional

*   Type: `string` ([Guidance text](section-properties-tasks-task-properties-actions-action-properties-guidance-text.md))

*   cannot be null

*   defined in: [Section](section-properties-tasks-task-properties-actions-action-properties-guidance-text.md "uk.gov.education/rsd/cctc/section#/properties/tasks/items/properties/actions/items/properties/guidance_text")

### guidance\_text Type

`string` ([Guidance text](section-properties-tasks-task-properties-actions-action-properties-guidance-text.md))
