# Api

The application has an Api for creating projects via a POST endpoint (TBA)

## Api key generation

Other applications can authenticate to our Api via a key. The keys are stored
in the `api_keys` table and are a simple ActiveRecord object with an api_key 
token (UUID) and an `expires_at` Datetime (initially set to 3 years' time).

To generate an Api key for a user, use the `api_key:generate` task.

For production users, this task must be run by first
[accessing the production console](console-and-logs.md), then running 
`api_key:generate['Key for Foobar application']`. Use the argument to briefly
describe who or what the Api Key is for. Send the generated Api key to the user
using a secure method if possible (for example, sharing in 1Password).
