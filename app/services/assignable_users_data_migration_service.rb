class AssignableUsersDataMigrationService
  def initialize(users)
    @users = users
  end

  def migrate!
    @users.each do |user|
      user.write_attribute(:assign_to_project, true) if user.add_new_project?
    end
  end
end
