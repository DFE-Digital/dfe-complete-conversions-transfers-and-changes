require "rails_helper"

RSpec.feature "Users can view a list of projects for a local authority" do
  before do
    sign_in_with_user(user)
    mock_all_academies_api_responses
  end

  let(:user) { create(:user, email: "user@education.gov.uk") }

  context "when the local authoritty cannot be found" do
    scenario "they see a 404 error" do
      visit by_local_authority_all_local_authorities_projects_path("000")

      expect(page).to have_http_status(:not_found)
    end
  end

  context "when there are projects for the local authority" do
    scenario "they see the list of projects" do
      establishment = build(:academies_api_establishment, urn: 123456, local_authority_code: "100")
      local_authority = create(:local_authority, code: "100")
      project = create(:conversion_project, urn: 123456, local_authority: local_authority)
      allow_any_instance_of(Project).to receive(:establishment).and_return(establishment)

      visit by_local_authority_all_local_authorities_projects_path("100")

      within("tbody > tr:first-child") do
        expect(page).to have_content(project.establishment.name)
        expect(page).to have_content(project.urn)
      end
    end

    scenario "when there are enough projects to page they see a pager" do
      local_authority = create(:local_authority, code: "100")
      21.times do
        create(:conversion_project, local_authority: local_authority)
      end
      establishment = build(:academies_api_establishment, urn: 123456, local_authority_code: "100")
      allow_any_instance_of(Project).to receive(:establishment).and_return(establishment)

      visit by_local_authority_all_local_authorities_projects_path("100")

      expect(page).to have_css(".govuk-pagination")
    end
  end
end
