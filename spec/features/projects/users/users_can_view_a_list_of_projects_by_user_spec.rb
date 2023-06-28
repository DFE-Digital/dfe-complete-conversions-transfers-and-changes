require "rails_helper"

RSpec.feature "Users can view a list of projects for a user" do
  before do
    sign_in_with_user(user)
    mock_all_academies_api_responses
  end

  let(:user) { create(:user, email: "user@education.gov.uk") }

  context "when a user has no projects" do
    scenario "they see an empty message" do
      visit by_user_all_users_projects_path(user)

      expect(page).to have_content("Projects for #{user.full_name}")
      expect(page).to have_content("There are no projects")
    end
  end

  context "when a user has projects" do
    scenario "they see the project listed" do
      project = create(:conversion_project, assigned_to: user, urn: 103835)

      visit by_user_all_users_projects_path(user)

      expect(page).to have_content("Projects for #{user.full_name}")
      expect(page).to have_content(project.urn)
    end
  end

  context "when the user is not valid" do
    scenario "it returns 404 not found" do
      visit "/projects/all/users/not-a-valid-user"

      expect(page).to have_http_status(:not_found)
    end
  end
end
