require "rails_helper"

RSpec.feature "Users can view a list of projects for a given region" do
  before do
    sign_in_with_user(user)
    mock_all_academies_api_responses
  end

  let(:user) { create(:user, email: "user@education.gov.uk") }

  context "when a region has a project" do
    scenario "they see the project listed" do
      project = create(:conversion_project, region: "london", urn: 103835)
      completed_project = create(:conversion_project, completed_at: Date.today, region: "london", urn: 121813)

      visit by_region_all_regions_projects_path("london")

      expect(page).to have_content(project.urn)
      expect(page).not_to have_content(completed_project.urn)
    end
  end

  context "when a project is unassigned" do
    scenario "they see the project listed" do
      project = create(:conversion_project, region: "london", urn: 103835, assigned_to: nil)

      visit by_region_all_regions_projects_path("london")

      expect(page).to have_content(project.urn)
      expect(page).to have_content("Not yet assigned")
    end
  end

  context "when there are no projects for the region" do
    scenario "they see an helpful message" do
      create(:conversion_project, completed_at: Date.today, region: "london", urn: 121813)

      visit by_region_all_regions_projects_path("london")

      expect(page).to have_content("There are no projects")
    end
  end

  context "when the region not valid" do
    scenario "they see a 404 error" do
      visit by_region_all_regions_projects_path("not_a_region")

      expect(page).to have_http_status(:not_found)
    end
  end
end
