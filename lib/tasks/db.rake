# :nocov:
namespace :db do
  desc "Add the EnforceUniquenessOfProjectUrn db trigger"
  # In theory this trigger should be included in structure.sql if
  # we opt to use that instead of schema.rb. But it isn't and in
  # any case trying to load the structure from stucture.sql with TinyTDS
  # fails due to lack of escaping on the "key# keyword....
  task add_enforce_uniqueness_of_project_urn_trigger: :environment do
    path = "#{Rails.root}/db/triggers/enforce_unique_urns_on_active_and_inactive_projects.sql"
    sql = File.read(path)
    ActiveRecord::Base.connection.execute sql
  end
end
# :nocov:
