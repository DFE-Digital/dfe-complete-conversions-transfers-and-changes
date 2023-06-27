require "rails_helper"

RSpec.feature "Users can view another users projects" do
  before do
    sign_in_with_user(user)
    mock_all_academies_api_responses
  end

  let(:user) { create(:user, email: "user@education.gov.uk") }
  let(:other_user) { create(:user, email: "other.user@education.gov.uk", first_name: "Other", last_name: "User") }

  scenario "by user id" do
    user_project = create(:conversion_project, assigned_to: other_user)
    other_project = create(:conversion_project, urn: 153234)

    visit by_user_user_projects_path(other_user.id)

    expect(page).to have_content(other_user.full_name)
    expect(page).to have_content(user_project.urn)
    expect(page).not_to have_content(other_project.urn)
  end
end
