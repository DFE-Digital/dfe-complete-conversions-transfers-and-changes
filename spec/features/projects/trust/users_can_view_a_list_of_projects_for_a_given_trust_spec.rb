require "rails_helper"

RSpec.feature "Users can view a list of projects for a given trust" do
  before do
    sign_in_with_user(user)
    mock_all_academies_api_responses
  end

  let(:user) { create(:user, email: "user@education.gov.uk") }

  context "when a trust has no projects" do
    scenario "they see an empty message" do
      trust = build(:academies_api_trust)

      visit by_trust_all_trust_projects_path(trust.ukprn)

      expect(page).to have_content("Projects for #{trust.name}")
      expect(page).to have_content("There are no projects for #{trust.name}")
    end
  end

  context "when a trust has a project" do
    scenario "they see the project listed" do
      project = create(:conversion_project, incoming_trust_ukprn: 10060639)
      trust = build(:academies_api_trust, ukprn: project.incoming_trust_ukprn)

      visit by_trust_all_trust_projects_path(10060639)

      expect(page).to have_content("Projects for #{trust.name}")
      expect(page).to have_content(project.urn)
    end
  end
end
