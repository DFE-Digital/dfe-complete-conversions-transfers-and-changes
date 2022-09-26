# README

## Top-level Schemas

*   [Action](./action.md "A single action which can be taken within a task") – `/schemas/action`

*   [Multi-checkbox action](./multi-checkbox.md "An action represented by multiple checkboxes") – `/schemas/actions/multi-checkbox`

*   [Section](./section.md "A single section within a task list") – `/schemas/section`

*   [Single-checkbox action](./single-checkbox.md "An action represented by a single checkbox") – `/schemas/actions/single-checkbox`

*   [Task list](./tasklist.md "A top-level definition of a task list") – `/schemas/tasklist`

## Other Schemas

### Objects

*   [Task](./section-properties-tasks-task.md "A task on the task list, which contains one or more actions") – `/schemas/section#/properties/tasks/items`

### Arrays

*   [Actions](./section-properties-tasks-task-properties-actions.md "A list of actions which collectively make up a task") – `/schemas/section#/properties/tasks/items/properties/actions`

*   [List of sections](./tasklist-properties-list-of-sections.md "A list of names of section definition files, in the order they should appear") – `/schemas/tasklist#/properties/sections`

*   [Sub-actions](./multi-checkbox-properties-sub-actions.md "A list of the individual items to appear as checkboxes within the action") – `/schemas/actions/multi-checkbox#/properties/sub-actions`

*   [Sub-actions](./multi-checkbox-properties-sub-actions.md "A list of the individual items to appear as checkboxes within the action") – `/schemas/actions/multi-checkbox#/properties/sub-actions`

*   [Tasks](./section-properties-tasks.md "A list of tasks within a section") – `/schemas/section#/properties/tasks`

## Version Note

The schemas linked above follow the JSON Schema Spec version: `https://json-schema.org/draft/2020-12/schema`
