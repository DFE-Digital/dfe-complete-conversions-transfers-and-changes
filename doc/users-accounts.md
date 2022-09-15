# User accounts

## Introduction

Our users sign in to access the application.

The authentication is handled by the DfE Active Directory via Omniatuth.

We store registered users in a database table, and authorise them to perform
tasks in the application.

Right now we are prioritising delivering a valuable end-to-end user journey over
optimal user management, therefore the development team has to manage user
accounts.

## Roles

We have three user roles:

### Team Lead

When `team_leader` is true.

Team leaders can:

- view all projects
- assign and re-assign caseworkers to projects
- re-assign regional delivery officers to projects

### Regional delivery officer

When `regional_delivery_officer` is true.

Regional delivery officers can:

- create (AKA handover) new projects
- view the projects that they are assigned by their role

### Caseworker (AKA Regional Caseworker)

When `caseworker` is true:

Caseworkers can:

- view and update the Projects they are assigned by their role

## Creating a new user

A basic user with no authorisation can be created:

```bash
bin/rails users:create EMAIL_ADDRESS=user.name@education.gov.uk
```

At least the `caseworker` role will need to be assigned to the new user on the
Rails console:

```bash
bin/rails console

User.find_by(email: "user.name@education.gov.uk").update(caseworker: true)
```

## Importing users in bulk

We can import users in bulk from a CSV file.

To use the `users:import` task, run:

```bash
bin/rails users:import CSV_PATH="<path relative to the project root>"
```

The headers of the CSV must be consistent with the attributes on the `user`
model. Boolean values can be indicated by `0` and `1`, all values should be
provided to avoid not-null constraint errors. For example:

| email                       | first_name | last_name | team_leader | regional_delivery_officer | caseworker |
| --------------------------- | ---------- | --------- | ----------- | ------------------------- | ---------- |
| john.doe@education.gov.uk   | John       | Doe       | 1           | 0                         | 0          |
| jane.doe@education.gov.uk   | Jane       | Doe       | 0           | 1                         | 0          |
| joseph.doe@education.gov.uk | Joseph     | Doe       | 0           | 0                         | 1          |
