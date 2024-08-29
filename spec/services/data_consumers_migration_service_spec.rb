require "rails_helper"

RSpec.describe DataConsumersMigrationService do
  it "moves all ESFA and AOPU users to the new Data consumers team" do
    create(:user, team: :education_and_skills_funding_agency, email: "user1@education.gov.uk")
    create(:user, team: :academies_operational_practice_unit, email: "user2@education.gov.uk")
    create(:regional_casework_services_user, email: "user3@education.gov.uk")

    DataConsumersMigrationService.new.migrate!

    expect(User.count).to eq(3)
    expect(User.data_consumers_team.count).to eq(2)
  end

  it "handles any invalid users" do
    user = build(:user, team: :education_and_skills_funding_agency, email: "user@education.co.uk")
    user.save(validate: false)

    DataConsumersMigrationService.new.migrate!

    expect(User.count).to eq(1)
    expect(User.data_consumers_team.count).to eq(1)
  end
end
