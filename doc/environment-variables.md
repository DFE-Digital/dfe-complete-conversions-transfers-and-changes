# Environment variables

We have three production environments i.e. where Rails is running in
'production' with RAILS_ENV="production":

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
