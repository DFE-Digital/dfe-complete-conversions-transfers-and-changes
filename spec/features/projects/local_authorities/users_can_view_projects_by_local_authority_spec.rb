require "rails_helper"

RSpec.feature "Users can view a list of local authorities that have projects" do
  before do
    sign_in_with_user(user)
    mock_all_academies_api_responses
  end

  let(:user) { create(:user, email: "user@education.gov.uk") }

  context "when there are no projects to fetch local authorities for" do
    scenario "they see an empty message" do
      visit all_local_authorities_projects_path

      expect(page).to have_content("There are no local authorities with project")
    end
  end

  context "when there are projects to fetch trusts for" do
    scenario "they see the trust listed and a link" do
      establishment = build(:academies_api_establishment, urn: 123456, local_authority_code: "100")
      local_authority = create(:local_authority, code: "100")
      create(:conversion_project, urn: 123456, local_authority: local_authority)
      allow_any_instance_of(Project).to receive(:establishment).and_return(establishment)

      visit all_local_authorities_projects_path

      within("tbody > tr:first-child") do
        expect(page).to have_content(local_authority.name)
        expect(page).to have_content(local_authority.code)
        expect(page).to have_content("1")
        expect(page).to have_link(local_authority.name, href: by_local_authority_all_local_authorities_projects_path(local_authority.code))
      end
    end
  end
end
