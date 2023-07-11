require "rails_helper"

RSpec.feature "Users can view the other users in their team" do
  before do
    sign_in_with_user(user)
  end

  let(:user) { create(:user, :caseworker, team: "regional_casework_services") }

  scenario "they cannot see users from other teams" do
    other_user = create(:user, :regional_delivery_officer, team: "london")

    visit users_team_projects_path

    expect(page).to_not have_content(other_user.full_name)
  end
end
