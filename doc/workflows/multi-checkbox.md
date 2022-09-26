# Multi-checkbox action Schema

```txt
/schemas/actions/multi-checkbox
```

An action represented by multiple checkboxes. Considered complete when all boxes in the action are checked.

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                                          |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :------------------------------------------------------------------------------------------------------------------ |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [multi-checkbox.schema.json](../../app/workflows/schemas/actions/multi-checkbox.schema.json "open original schema") |

## Multi-checkbox action Type

`object` ([Multi-checkbox action](multi-checkbox.md))

## Multi-checkbox action Examples

```yaml
title: Check the document has been signed and sealed
sub-actions:
  - Document has been signed
  - Document has been sealed

```

# Multi-checkbox action Properties

| Property                    | Type    | Required | Nullable       | Defined by                                                                                                                  |
| :-------------------------- | :------ | :------- | :------------- | :-------------------------------------------------------------------------------------------------------------------------- |
| [sub-actions](#sub-actions) | `array` | Required | cannot be null | [Multi-checkbox action](multi-checkbox-properties-sub-actions.md "/schemas/actions/multi-checkbox#/properties/sub-actions") |

## sub-actions

A list of the individual items to appear as checkboxes within the action.

`sub-actions`

*   is required

*   Type: `string[]`

*   cannot be null

*   defined in: [Multi-checkbox action](multi-checkbox-properties-sub-actions.md "/schemas/actions/multi-checkbox#/properties/sub-actions")

### sub-actions Type

`string[]`

### sub-actions Constraints

**minimum number of items**: the minimum number of items for this array is: `2`
