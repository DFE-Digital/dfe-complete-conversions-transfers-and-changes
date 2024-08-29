# Data migration service
#
# This data migration is designed to be run in production and then deleted
#
# It moves any users in the `academies_operational_practice_unit` or
# `education_and_skills_funding_agency` team into the `data_consumers`
# team
#
# To run:
#
# bin/rails runner DataConsumersMigrationService.new.migrate!
#
class DataConsumersMigrationService
  def migrate!
    esfa_users = User.education_and_skills_funding_agency_team
    puts "#{esfa_users.count} ESFA users to update"
    esfa_users.each do |user|
      user.team = :data_consumers
      user.save!(validate: false)
    end

    aopu_users = User.academies_operational_practice_unit_team
    puts "#{aopu_users.count} AOPU users to update"
    aopu_users.each do |user|
      user.team = :data_consumers
      user.save!(validate: false)
    end

    puts "#{User.data_consumers_team.count} Data consumer users after migration"
  end
end
