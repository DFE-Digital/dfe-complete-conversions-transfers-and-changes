# README

## Top-level Schemas

*   [Action](./action.md "A single action which can be taken within a task") – `/uk.gov.education/rsd/cctc/action`

*   [Section](./section.md "A single section within a task list") – `/uk.gov.education/rsd/cctc/section`

*   [Task list](./tasklist.md "A top-level definition of a task list") – `/uk.gov.education/rsd/cctc/tasklist`

## Other Schemas

### Objects

*   [Task](./section-properties-tasks-task.md "A task on the task list, which contains one or more actions") – `/uk.gov.education/rsd/cctc/section#/properties/tasks/items`

### Arrays

*   [Actions](./section-properties-tasks-task-properties-actions.md "A list of actions which collectively make up a task") – `/uk.gov.education/rsd/cctc/section#/properties/tasks/items/properties/actions`

*   [List of sections](./tasklist-properties-list-of-sections.md "A list of names of section definition files, in the order they should appear") – `/uk.gov.education/rsd/cctc/tasklist#/properties/sections`

*   [Tasks](./section-properties-tasks.md "A list of tasks within a section") – `/uk.gov.education/rsd/cctc/section#/properties/tasks`

## Version Note

The schemas linked above follow the JSON Schema Spec version: `https://json-schema.org/draft/2020-12/schema`
