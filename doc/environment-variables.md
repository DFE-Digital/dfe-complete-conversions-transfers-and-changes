# Environment variables

See [.env.example](./.env.example) for local environment variables.

We have three live environments i.e. where Rails is running in 'production' with
RAILS_ENV="production":

- development
- test
- production

These environments require extra variables to function, these are stored in the
Terraform tfvar files.

`SQL_SERVER_SCHEMA_NAME`

This is the SQL Server schema name used in production environments and must be
set in those, not used locally, see
[SQL Server documentation](./microsoft-sql-server.md) for more information on
schema in this context.

`HOSTNAME`

This is the host name for the running application in production environments, we
set this into the `Rails.application.config.hosts` array, see:

https://guides.rubyonrails.org/configuring.html#actiondispatch-hostauthorization

`ALLOWED_HOSTS`

This is a comma separated list of hostnames that the application will respond to
behind the CDN, it usually includes the container host name and the cdn
hostname, see:

https://guides.rubyonrails.org/configuring.html#actiondispatch-hostauthorization

`SENTRY_ENV`

This is the environment name that will appear in Sentry, so one of development,
test or production.

See: https://docs.sentry.io/product/sentry-basics/environments/

`SENTRY_DSN`

This is the 'Client Keys' for the project in Sentry UI, it is a url starting
https://

See: https://docs.sentry.io/product/sentry-basics/dsn-explainer/

`NO_COVERAGE`

Set this to `true` to stop Simplecov generating coverage reports.

Not setting the variable or setting it to `false` will run Simplecov, this is
the default behaviour.

We only use this in CI to run our AXE accessibility checks. See:

https://github.com/DFE-Digital/dfe-complete-conversions-transfers-and-changes/blob/505ed05431c8398db9dd3ceb51918b77ea148761/script/all/test-accessibility#L6

`CONTAINER_VNET`

Contains a range of IP addresses used by the monitoring health probes. This
range is added to the `ALLOWED_HOSTS` on production, so that the probes can hit
the `/healthcheck` endpoint to confirm the app is up & running.

`APPLICATION_INSIGHTS_KEY`

The instrumentation key for Microsoft Application Insights.
