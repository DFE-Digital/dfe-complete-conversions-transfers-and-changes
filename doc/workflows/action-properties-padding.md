# Padding Schema

```txt
/uk.gov.education/rsd/cctc/action#/properties/padding
```

Adjust the amount of padding (spacing above) applied to the action.

| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                    |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :-------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [action.schema.json\*](../../app/workflows/schemas/action.schema.json "open original schema") |

## padding Type

`string` ([Padding](action-properties-padding.md))

## padding Constraints

**enum**: the value of this property must be equal to one of the following values:

| Value       | Explanation |
| :---------- | :---------- |
| `"normal"`  |             |
| `"reduced"` |             |

## padding Default Value

The default value is:

```json
"normal"
```
