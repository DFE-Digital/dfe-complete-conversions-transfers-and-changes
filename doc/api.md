# API

The application has an API for creating projects.

## Automatic user generation

If a user is posted that is not in the application database, a record is created
and assigned to the project, effectively allowing that user to sign in.

Only @education.gov.uk addresses are valid and the user would still have to
authenticate with their DfE Microsoft account to access the application.

## API key generation

Other applications can authenticate to our API via a key. The keys are stored in
the `api_keys` table and are a simple ActiveRecord object with an api_key token
(UUID) and an `expires_at` Datetime (initially set to 3 years' time).

To generate an API key for a user, use the `api_key:generate` task.

For production users, this task must be run by first
[accessing the production console](console-and-logs.md), then running
`api_key:generate['Key for Foobar application']`. Use the argument to briefly
describe who or what the API key is for. Send the generated API key to the user
using a secure method if possible (for example, sharing in 1Password).
