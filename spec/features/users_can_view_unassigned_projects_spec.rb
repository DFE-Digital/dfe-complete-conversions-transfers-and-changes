require "rails_helper"

RSpec.feature "Users can view a list of projects" do
  before do
    (100001..100006).each do |urn|
      mock_successful_api_responses(urn: urn, ukprn: 10061021)
    end

    allow(EstablishmentsFetcher).to receive(:new).and_return(mock_establishments_fetcher)
    allow(IncomingTrustsFetcher).to receive(:new).and_return(mock_trusts_fetcher)
  end

  let(:mock_establishments_fetcher) { double(EstablishmentsFetcher, call: true) }
  let(:mock_trusts_fetcher) { double(IncomingTrustsFetcher, call: true) }
  let(:team_leader) { create(:user, :team_leader, email: "teamleader@education.gov.uk") }
  let(:regional_delivery_officer) { create(:user, :regional_delivery_officer, email: "regionaldeliveryofficer@education.gov.uk") }
  let(:caseworker) { create(:user, :caseworker, email: "caseworker@education.gov.uk") }

  let!(:unassigned_project) {
    create(
      :conversion_project,
      urn: 100001,
      assigned_to_regional_caseworker_team: true
    )
  }
  let!(:assigned_project) {
    create(
      :conversion_project,
      urn: 100002,
      assigned_to: caseworker
    )
  }

  context "When the user is a Team leader" do
    before do
      sign_in_with_user(team_leader)
    end

    scenario "user can see the unassigned projects tab" do
      visit projects_path

      expect(page).to have_content("Unassigned projects")
    end

    scenario "user can see the list of unassigned projects" do
      visit projects_path

      click_on "Unassigned projects"

      expect(page).to have_content("URN 100001")
      expect(page).to_not have_content("URN 100002")
    end
  end

  context "When the user is a Regional Delivery Officer" do
    before do
      sign_in_with_user(regional_delivery_officer)
    end

    scenario "user cannot see the unassigned projects tab" do
      visit projects_path

      expect(page).to_not have_content("Unassigned projects")
    end
  end

  context "When the user is a Caseworker" do
    before do
      sign_in_with_user(caseworker)
    end

    scenario "user cannot see the unassigned projects tab" do
      visit projects_path

      expect(page).to_not have_content("Unassigned projects")
    end
  end
end
