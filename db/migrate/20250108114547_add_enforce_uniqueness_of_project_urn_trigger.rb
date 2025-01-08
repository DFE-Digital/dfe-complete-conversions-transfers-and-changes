class AddEnforceUniquenessOfProjectUrnTrigger < ActiveRecord::Migration[7.1]
  def up
    path = "#{Rails.root}/db/triggers/enforce_unique_urns_on_active_and_inactive_projects.sql"
    sql = File.read(path)
    ActiveRecord::Base.connection.execute sql
  end

  def down
    sql = <<~SQL
      IF OBJECT_ID ('EnforceUniquenessOfProjectUrn', 'TR') IS NOT NULL
      DROP TRIGGER EnforceUniquenessOfProjectUrn;
    SQL

    execute sql
  end
end
