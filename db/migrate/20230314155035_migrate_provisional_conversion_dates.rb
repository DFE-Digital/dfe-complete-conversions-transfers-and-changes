class MigrateProvisionalConversionDates < ActiveRecord::Migration[7.0]
  def up
    Project.find_each do |project|
      ProjectConversionDateMigrator.new(project).migrate_up!
    end
  end
end
