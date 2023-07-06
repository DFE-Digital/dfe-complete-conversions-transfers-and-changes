require "rails_helper"

RSpec.feature "Users can view a list users" do
  before do
    sign_in_with_user(user)
    mock_all_academies_api_responses
  end

  let(:user) { create(:user, email: "user@education.gov.uk", team: :london) }

  context "when there are no projects to fetch users for" do
    scenario "they see an empty message" do
      visit all_users_projects_path

      expect(page).to have_content("There are no users with projects")
    end
  end

  context "when there are projects to fetch users for" do
    scenario "they see the user and a count of projects with a link" do
      create(:conversion_project, assigned_to: user)

      visit all_users_projects_path

      within("tbody > tr:first-child") do
        expect(page).to have_content(user.full_name)
        expect(page).to have_content("London")
        expect(page).to have_content("1")
        expect(page).to have_link("View projects", href: by_user_all_users_projects_path(user))
      end
    end
  end
end
