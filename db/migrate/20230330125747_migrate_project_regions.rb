class MigrateProjectRegions < ActiveRecord::Migration[7.0]
  def up
    Project.all.each do |project|
      ProjectRegionMigrator.new(project).migrate_up!
    end
  end
end
