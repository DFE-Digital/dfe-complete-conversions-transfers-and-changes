require "rails_helper"

RSpec.feature "Users can view a list of projects for a given form a MAT trust" do
  before do
    sign_in_with_user(user)
  end

  let(:user) { create(:user, email: "user@education.gov.uk") }

  context "when a trust has no projects i.e. the trust does not exist!" do
    scenario "it returns not found" do
      visit by_trust_reference_all_trusts_projects_path("TR12345")

      expect(page).to have_http_status :not_found
    end
  end

  context "when a trust has a project" do
    scenario "they see the project listed" do
      mock_all_academies_api_responses
      project = create(
        :conversion_project,
        new_trust_name: "THE BIG TRUST",
        new_trust_reference_number: "TR12345",
        incoming_trust_ukprn: nil
      )

      visit by_trust_reference_all_trusts_projects_path("TR12345")

      expect(page).to have_content("Projects for The Big Trust")
      expect(page).to have_content(project.establishment.name)
    end
  end
end
