# Action Schema

```txt
/schemas/action
```

A single action which can be taken within a task.

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                  |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :------------------------------------------------------------------------------------------ |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Forbidden             | none                | [action.schema.json](../../app/workflows/schemas/action.schema.json "open original schema") |

## Action Type

`object` ([Action](action.md))

all of

*   [Untitled undefined type in Action](action-allof-0.md "check type definition")

*   [Untitled undefined type in Action](action-allof-1.md "check type definition")

## Action Examples

```yaml
title: Check new URN has been issued
hint: Check that the URN for the new school has been issued.
guidance_summary: What to check?
guidance_text: You can find [a list of what to check online](https://example.com).

```

# Action Properties

| Property                               | Type     | Required | Nullable       | Defined by                                                                                     |
| :------------------------------------- | :------- | :------- | :------------- | :--------------------------------------------------------------------------------------------- |
| [type](#type)                          | `string` | Optional | cannot be null | [Action](action-properties-type.md "/schemas/action#/properties/type")                         |
| [title](#title)                        | `string` | Required | cannot be null | [Action](action-properties-title.md "/schemas/action#/properties/title")                       |
| [hint](#hint)                          | `string` | Optional | cannot be null | [Action](action-properties-hint.md "/schemas/action#/properties/hint")                         |
| [guidance\_summary](#guidance_summary) | `string` | Optional | cannot be null | [Action](action-properties-guidance_summary.md "/schemas/action#/properties/guidance_summary") |
| [guidance\_text](#guidance_text)       | `string` | Optional | cannot be null | [Action](action-properties-guidance_text.md "/schemas/action#/properties/guidance_text")       |

## type



`type`

*   is optional

*   Type: `string`

*   cannot be null

*   defined in: [Action](action-properties-type.md "/schemas/action#/properties/type")

### type Type

`string`

### type Constraints

**enum**: the value of this property must be equal to one of the following values:

| Value               | Explanation |
| :------------------ | :---------- |
| `"single-checkbox"` |             |

### type Default Value

The default value is:

```json
"single-checkbox"
```

## title



`title`

*   is required

*   Type: `string`

*   cannot be null

*   defined in: [Action](action-properties-title.md "/schemas/action#/properties/title")

### title Type

`string`

## hint



`hint`

*   is optional

*   Type: `string`

*   cannot be null

*   defined in: [Action](action-properties-hint.md "/schemas/action#/properties/hint")

### hint Type

`string`

## guidance\_summary



`guidance_summary`

*   is optional

*   Type: `string`

*   cannot be null

*   defined in: [Action](action-properties-guidance_summary.md "/schemas/action#/properties/guidance_summary")

### guidance\_summary Type

`string`

## guidance\_text



`guidance_text`

*   is optional

*   Type: `string`

*   cannot be null

*   defined in: [Action](action-properties-guidance_text.md "/schemas/action#/properties/guidance_text")

### guidance\_text Type

`string`
