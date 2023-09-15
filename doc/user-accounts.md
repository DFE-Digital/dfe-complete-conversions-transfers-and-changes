# User accounts

## Introduction

Our users sign in to access the application.

The authentication is handled by the DfE Active Directory via Omniatuth.

We store registered users in a database table, and authorise them to perform
tasks in the application.

Right now we are prioritising delivering a valuable end-to-end user journey over
optimal user management, therefore the development team has to manage user
accounts, this is detailed below.

## Creating a user account

See the [seeding the database documentation](/doc/seeding-the-database.md).

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
DfE T1 tenant `AZURE_APPLICATION_CLIENT_ID` application id, this is the same
across all environments and is the application registration id linked above
`AZURE_APPLICATION_CLIENT_SECRET` secret, each environment has its own secret

### Secrets

The secrets are set to expire, view and manage the applications secrets in
Azure:

https://portal.azure.com/#view/Microsoft_AAD_RegisteredApps/ApplicationMenuBlade/~/Credentials/appId/05b7db93-6384-4b44-9d27-23eb6bd97366/isMSAApp~/false
