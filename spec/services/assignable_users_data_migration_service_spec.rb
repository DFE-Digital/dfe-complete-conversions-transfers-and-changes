require "rails_helper"

RSpec.describe AssignableUsersDataMigrationService do
  it "set any regional delivery officers asssign_to_project flag to true" do
    user = create(:regional_delivery_officer_user, assign_to_project: false)

    described_class.new(User.all).migrate!

    expect(user.reload.assign_to_project).to be true
  end

  it "only acts on regional delivery officer users via the add_new_project attribute" do
    user = create(:regional_delivery_officer_user, assign_to_project: false)
    other_user = create(:service_support_user)

    described_class.new(User.all).migrate!

    expect(user.reload.assign_to_project).to be true
    expect(other_user.reload.assign_to_project).to be false
  end
end
