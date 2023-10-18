# Seeding the database

You will want to seed your local database with the following

- at least one user
- the local authorities
- the director of child services
- GIAS data

## Seed files

We have 3 seed files stored on the
[DfE SharePoint (sign in required)](https://educationgovuk.sharepoint.com/:f:/r/sites/ServiceDeliveryDirectorate/Shared%20Documents/A2C%20and%20Interventions/Complete%20conversions,%20transfers%20and%20changes/Technical/seed_files?csf=1&web=1&e=AeMvUf) -
download these.

**IMPORTANT** these files contain personally identifiable information (PII) and
must be handled as such!

## User account

Read the advice in the [user accounts](/doc/user-accounts.md)

With a DfE Active Directory account setup, you will need to create that user in
the local database in order to authorise the account:

- open a Rails console `bin/rails console`
- run the following
  `User.create! first_name: "value", last_name: "value", email: "first_name.last_name@education.gov.uk", team: :team_symbol`

### A note on the `team_symbol`

All users belong to a team that is modelled in the
[Teamable concern](https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/blob/chore/seeding-docs/app/models/concerns/teamable.rb).

### A note on the session cookie

Your user account id is stored in the session cookie, if you have reset your
local database, you may need to delete the `SESSION` cookie in your browser in
order to sign in with the new user account.

## Local authorities

Run the importer against the seed file, on zsh this looks like:

```
bin/rails local_authorities:import\[/path/to/local_authorities_april_2023.csv]
```

## Director of child services

Run the importer against the seed file, on zsh this looks like:

```
bin/rails director_of_child_services:import\[/path/to/director_of_child_services.csv]
```

## GIAS data

See [importing GIAS data documentation](/doc/import-gias-data.md).
