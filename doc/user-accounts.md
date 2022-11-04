# User accounts

## Introduction

Our users sign in to access the application.

The authentication is handled by the DfE Active Directory via Omniatuth.

We store registered users in a database table, and authorise them to perform
tasks in the application.

Right now we are prioritising delivering a valuable end-to-end user journey over
optimal user management, therefore the development team has to manage user
accounts, this is detailed below.

## Active Directory

We leverage the existing DfE Active Directory that is hosted in Azure. This can
get confusing as there are multiple Azure tenants running Active Directory.

To authenticate users we use the directory in the DfE T1
(Educationgovuk.onmicrosoft.com) tenant.

The application is registered as a consumer of this directory:

Name: complete-conversions-transfers-and-changes
ID:05b7db93-6384-4b44-9d27-23eb6bd97366

Link to registration in Azure:
https://portal.azure.com/#blade/Microsoft_AAD_RegisteredApps/BrandingBlade/appId/05b7db93-6384-4b44-9d27-23eb6bd97366/isMSAApp/

This registration contains the secrets used to allow the application to utilise
the directory, we provide these as environment variables:

`AZURE_TENANT_ID` tenant id, this is the same across all environments and is the
DfE T1 tenant  
`AZURE_APPLICATION_CLIENT_ID` application id, this is the same across all
environments and is the application registration id linked above
`AZURE_APPLICATION_CLIENT_SECRET` secret, each environment has its own secret

### Secrets

The secrets are set to expire, view and manage the applications secrets in
Azure:

https://portal.azure.com/#view/Microsoft_AAD_RegisteredApps/ApplicationMenuBlade/~/Credentials/appId/05b7db93-6384-4b44-9d27-23eb6bd97366/isMSAApp~/false

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

The service will need to recognise you as a user, use the `users:create` task to
add your DfE email address. This will create a basic user with no assigned
roles.

You must pass your email address, first name, and last name as comma separated
arguments. For example:

```bash
bin/rails users:create["john.doe@education.gov.uk","John","Doe"]
```

> **NOTE:** In some shells, such as Zsh, square brackets must be escaped.

At least the `caseworker` role will need to be assigned to the new user on the
Rails console:

```bash
bin/rails console

User.find_by(email: "john.doe@education.gov.uk").update(caseworker: true)
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
