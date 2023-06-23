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

      visit by_trust_all_trusts_projects_path(trust.ukprn)

      expect(page).to have_content("Projects for #{trust.name}")
      expect(page).to have_content("There are no projects for #{trust.name}")
    end
  end

  context "when a trust has a project" do
    scenario "they see the project listed" do
      project = create(:conversion_project, incoming_trust_ukprn: 10060639, urn: 103835)
      trust = build(:academies_api_trust, ukprn: project.incoming_trust_ukprn)
      completed_project = create(:conversion_project, completed_at: Date.today, incoming_trust_ukprn: 10060639, urn: 121813)

      visit by_trust_all_trusts_projects_path(10060639)

      expect(page).to have_content("Projects for #{trust.name}")
      expect(page).to have_content(project.urn)
      expect(page).not_to have_content(completed_project.urn)
    end
  end

  context "when a project is unassigned" do
    scenario "they see the project listed" do
      project = create(:conversion_project, incoming_trust_ukprn: 10060639, urn: 103835, assigned_to: nil)
      trust = build(:academies_api_trust, ukprn: project.incoming_trust_ukprn)

      visit by_trust_all_trusts_projects_path(10060639)

      expect(page).to have_content("Projects for #{trust.name}")
      expect(page).to have_content(project.urn)
      expect(page).to have_content("Not yet assigned")
    end
  end
end
