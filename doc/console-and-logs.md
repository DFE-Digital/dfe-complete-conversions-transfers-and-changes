# Accessing the console and logs

All environments are hosted in Azure and can be accessed via the Azure portal.

All developers on the team have access to the resources in Azure.

## Environments

### Development

[Console](#console-access) and [log](#log-access) access is available with no
further actions.

### Test and Production

A Privileged Identity Management (PIM) request will need to be raised before
console and logs for these environments can be accessed. A PIM request for the
`test` environment will be automatically approved; one for `production` will
need to be approved by another member of the team.

## Privileged Identity Management (PIM)

Steps to open a PIM:

- visit the [Azure Portal](https://portal.azure.com) and ensure you are in the
  `DfE Platform Identity` tenant (platform.education.gov.uk)
- Locate the PIM module
- Click on `My roles`
- Click on `Azure resources`
- Activate the `Contributor` role for the appropriate environment
- Select a time (usually 8 hours) and given a reason for the escalated
  privileges
- (Production only) Another member of the team can approve the PIM, you'll
  receive an email upon approval (you can all view your pending request in PIM
  module)
- Once approved your account will have access to the [Console](#console-access)
  and [logs](#log-access)

## Console access

To get console access to the running application:

- visit the [Azure Portal](https://portal.azure.com) and ensure you are in the
  `DfE Platform Identity`
- Locate the `Container Apps` module
- Locate the container you want, be careful as the names are very similar:
  - `s184d01-comp-complete-app` > development
  - `s184t01-comp-complete-app` > test
  - `s184p01-comp-complete-app` > production
- Click on the appropriate container
- Click on `Console`
- Choose `/bin/bash` and an interactive shell will start

## Log access

We have two options to view logs:

- log stream: live logs coming out of the current running container
- logs: database of all logs

### Log stream

To access the log stream:

- open a PIM for the appropriate environment
- visit the [Azure Portal](https://portal.azure.com) and ensure you are in the
  `DfE Platform Identity`
- Locate the `Container Apps` module
- Locate the container you want, be careful as the names are very similar:
  - `s184d01-comp-complete-app` > development
  - `s184t01-comp-complete-app` > test
  - `s184p01-comp-complete-app` > production
- Click on the appropriate container
- Click on `Log stream`
- An interactive log stream will start

### Logs

To access logs:

- open a PIM for the appropriate environment
- visit the [Azure Portal](https://portal.azure.com) and ensure you are in the
  `DfE Platform Identity`
- Locate the `Container Apps` module
- Locate the container you want, be careful as the names are very similar:
  - `s184d01-comp-complete-app` > development
  - `s184t01-comp-complete-app` > test
  - `s184p01-comp-complete-app` > production
- Click on the appropriate container
- Click on `Logs`

Logs are in an SQL like database, you can manipulate them however you choose, as
a starter:

```
ContainerAppConsoleLogs
| project TimeGenerated, Log, RevisionName
| order by TimeGenerated
```

This snippet will get you all the logs for the specified time period.

You can save queries for frequent use.
