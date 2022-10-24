# Action type Schema

```txt
/uk.gov.education/rsd/cctc/action#/properties/type
```

The type of action which the user will be shown.

| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                    |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :-------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [action.schema.json\*](../../app/workflows/schemas/action.schema.json "open original schema") |

## type Type

`string` ([Action type](action-properties-action-type.md))

## type Constraints

**enum**: the value of this property must be equal to one of the following values:

| Value               | Explanation |
| :------------------ | :---------- |
| `"single-checkbox"` |             |
| `"subheading"`      |             |

## type Default Value

The default value is:

```json
"single-checkbox"
```
