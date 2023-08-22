require "rails_helper"

RSpec.feature "Users can view a list regions that have projects" do
  before do
    sign_in_with_user(user)
    mock_all_academies_api_responses
  end

  let(:user) { create(:user, email: "user@education.gov.uk") }

  context "when there are no projects to fetch region for" do
    scenario "they see an empty message" do
      visit all_regions_projects_path

      expect(page).to have_content("There are no regions")
    end
  end

  context "when there are projects to fetch trusts for" do
    scenario "they see the trust listed and a link" do
      create(:conversion_project, region: "north_west")

      visit all_regions_projects_path

      within("tbody > tr:first-child") do
        expect(page).to have_content("North West")
        expect(page).to have_content("1")
        expect(page).to have_link("North West", href: by_region_all_regions_projects_path("north_west"))
      end
    end
  end
end
