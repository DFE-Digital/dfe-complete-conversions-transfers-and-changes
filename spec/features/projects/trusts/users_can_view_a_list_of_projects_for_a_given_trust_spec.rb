require "rails_helper"

RSpec.feature "Users can view a list of projects for a given trust" do
  before do
    sign_in_with_user(user)
    mock_academies_api_client_get_establishments_and_trusts
  end

  let(:user) { create(:user, email: "user@education.gov.uk") }

  context "when a trust has no projects" do
    scenario "they see an empty message" do
      visit by_trust_ukprn_all_trusts_projects_path(10010010)

      expect(page).to have_content("Projects for Trust Name")
      expect(page).to have_content("There are no projects for Trust Name")
    end
  end

  context "when a trust has a project" do
    scenario "they see the project listed" do
      project = create(:conversion_project, incoming_trust_ukprn: 10010010, urn: 123456)
      completed_project = create(:conversion_project, :completed, completed_at: Date.today, incoming_trust_ukprn: 10010010, urn: 165432)

      visit by_trust_ukprn_all_trusts_projects_path(10010010)

      expect(page).to have_content("Projects for Trust Name")
      expect(page).to have_content(project.urn)
      expect(page).not_to have_content(completed_project.urn)
    end
  end

  context "when a project is unassigned" do
    scenario "they see the project listed" do
      project = create(:conversion_project, incoming_trust_ukprn: 10010010, urn: 123456, assigned_to: nil)

      visit by_trust_ukprn_all_trusts_projects_path(10010010)

      expect(page).to have_content("Projects for Trust Name")
      expect(page).to have_content(project.urn)
      expect(page).to have_content("Not yet assigned")
    end
  end

  def mock_academies_api_client_get_establishments_and_trusts
    api_client = Api::AcademiesApi::Client.new

    establishment = double("Establishment", name: "Establishment Name", urn: "123456")
    trust = double("Trust", name: "Trust Name", ukprn: "10010010")

    allow(Api::AcademiesApi::Client).to receive(:new).and_return(api_client)

    allow(api_client).to receive(:get_establishments).and_return(Api::AcademiesApi::Client::Result.new([establishment], nil))
    allow(api_client).to receive(:get_trusts).and_return(Api::AcademiesApi::Client::Result.new([trust], nil))

    allow(api_client).to receive(:get_trust).and_return(Api::AcademiesApi::Client::Result.new(trust, nil))
    allow(api_client).to receive(:get_establishment).and_return(Api::AcademiesApi::Client::Result.new(establishment, nil))

    api_client
  end
end
