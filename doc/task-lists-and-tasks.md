# Task lists and tasks

Along with Projects, task lists and the tasks they contain make up the main data
model in the application.

## Task lists

### Adding a new task list

A new task list can be added by inheriting from the `BaseTaskList` class.

The new task list will need a table to store the actions than make up each task,
conventionally the table name must follow the class path, something like:

(For all examples, this is a _Conversion_ project and tasks data. For Transfer
projects, amend accordingly.)

Class path:

```
Conversion::TaskList
```

Table name:

```
conversion_tasks_data
```

The new task list must then declare a `layout` method that returns an array of
sections and tasks which is used to instantiate `Conversion::Task::*` form
objects. See the existing task lists to get a sense of this data structure:

```
[
    {
        identifier: :project_kick_off,
        tasks: [
                    Conversion::Task::HandoverTaskForm,
                    Conversion::Task::StakeholderKickOffTaskForm,
                    Conversion::Task::CheckAccuracyOfHigherNeedsTaskForm
                ]
    },
]
```

You'll see how each task list groups its own tasks in a `tasks` directory.

## Tasks

### Adding a new task

#### Rails generators

To make the task of creating new tasks simpler, Rails generators have been
created for the new task model:

```
bin/rails generate conversion:task TaskName
```

This will generate a migration, a Form object (inheriting from `BaseTaskForm`),
and `edit` view and a locale file for the task.

Edit the migration to add the data attributes to the database which the form
will collect. These will be stored in the `conversion_tasks_data` table and the
columns follow a specific naming convention (see existing forms for details).

Add the attribute names to the Form object for your task. If it is an optional
task, the Form should inherit from `BaseOptionalTaskForm` instead of
`BaseTaskForm`.

Edit the view to add your checkboxes, form fields etc.

Edit the locale file with your desired text.

### A note on notes

As there is no database representation of a task - the task identifier - its
class name, is used as a unique identifier for each task, class names must be
unique inside their scope, so this works out of the box and is part of the
convention we follow.

Users can link a note to a specific task, a 'task level note'. To achieve this
we use the task unique identifier as a key on the Note object.

All this means team must think about task level notes in the following to
situations to prevent orphaned notes:

#### Removing a task

When removing a task the team should consider any task level notes associated to
the task and delete any.

As already mentioned, the task identifier is unique within its own task list
scope, but there may be task with matching identifiers in other scopes,
therefore we have to delete the notes that belong to the the correct task list
type (the scope). Do so by loading only notes form the projects of the task list
type:

```
projects = Project.where(tasks_data_type: "Conversion::TasksData").map { |project| project.id }
Note.where(task_identifier: "<old task identifier>", project_id: projects).destroy_all
```

#### Renaming a task

When renaming a task, the task notes should be migrated to the new identifier:

```
projects = Project.where(tasks_data_type: "Conversion::TasksData").map { |project| project.id }
Note.where(task_identifier: "<old task identifier>", project_id: projects).update(task_identifier: "<new task identifier>")
```

#### Orphaned task notes

Orphaned task notes can be located in the database as needed should this advice
not be followed:

```
task_identifiers = Conversion::TaskList.new.tasks.map { |task| task.class.identifier }
projects = Project.where(tasks_data_type: "Conversion::TasksData").map { |project| project.id }
Note.where(project_id: projects).where.not(task_identifier: [task_identifiers, nil])
```
