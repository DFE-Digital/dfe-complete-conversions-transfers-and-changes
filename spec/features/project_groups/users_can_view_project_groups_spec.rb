require "rails_helper"

RSpec.feature "Users can view project groups" do
  let(:user) { create(:user, :caseworker) }
  let(:project) { create(:conversion_project, caseworker: user) }

  before do
    mock_all_academies_api_responses
    sign_in_with_user(user)

    create(:project_group, group_identifier: "GRP_12345678")
  end

  scenario "they can view all groups" do
    click_on "Groups"

    expect(page).to have_content "Groups"
    expect(page).to have_content "GRP_12345678"
  end
end
