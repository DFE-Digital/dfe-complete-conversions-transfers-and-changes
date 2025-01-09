#!/bin/bash
set -e

echo "ENTRYPOINT: Starting docker entrypoint…"

setup_database()
{
  echo "ENTRYPOINT: Running rake db:prepare…"
  # Migrate the database and if one doesn't exist then create one
  bundle exec rake db:prepare

  # Manually add our EnforceUniquenessOfProjectUrn trigger
  # In theory this trigger should be included in structure.sql if
  # we opt to use that instead of schema.rb. But it isn't and in
  # any case trying to load the structure from stucture.sql with TinyTDS
  # fails due to lack of escaping on the "key# keyword....
  echo "ENTRYPOINT: Running rake db:add_enforce_uniqueness_of_project_urn_trigger…"
  bundle exec rake db:add_enforce_uniqueness_of_project_urn_trigger

  echo "ENTRYPOINT: Finished database setup."
}

if [ -z ${DATABASE_URL+x} ]; then echo "Skipping database setup"; else setup_database; fi

echo "ENTRYPOINT: Finished docker entrypoint."
exec "$@"
