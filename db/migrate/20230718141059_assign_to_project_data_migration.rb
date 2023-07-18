class AssignToProjectDataMigration < ActiveRecord::Migration[7.0]
  def up
    AssignableUsersDataMigrationService.new(User.all).migrate!
  end
end
