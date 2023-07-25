require "rails_helper"

RSpec.feature "Users can view a list trusts" do
  before do
    sign_in_with_user(user)
    mock_academies_api_client_get_establishments_and_trusts
  end

  let(:user) { create(:user, email: "user@education.gov.uk") }

  context "when there are no projects to fetch trusts for" do
    scenario "they see an empty message" do
      visit all_trusts_projects_path

      expect(page).to have_content("There are no trusts")
    end
  end

  context "when there are projects to fetch trusts for" do
    scenario "they see the trust listed and a link" do
      create(:conversion_project, incoming_trust_ukprn: 10010010)

      visit all_trusts_projects_path

      within("tbody > tr:first-child") do
        expect(page).to have_content("Trust Name")
        expect(page).to have_content("TR100100")
        expect(page).to have_content("1")
        expect(page).to have_link("View projects"), href: by_trust_all_trusts_projects_path(10010010)
      end
    end

    scenario "when there are enough projects to page they see a pager" do
      mock_academies_api_client_get_establishments_and_trusts

      21.times do
        create(:conversion_project, incoming_trust_ukprn: 10010010)
      end

      visit by_trust_all_trusts_projects_path(10010010)

      expect(page).to have_css(".govuk-pagination")
    end
  end

  def mock_academies_api_client_get_establishments_and_trusts
    api_client = Api::AcademiesApi::Client.new

    establishment = double("Establishment", name: "Establishment Name", urn: "123456")
    trust = double("Trust", name: "Trust Name", ukprn: "10010010", group_identifier: "TR100100")

    allow(Api::AcademiesApi::Client).to receive(:new).and_return(api_client)

    allow(api_client).to receive(:get_establishments).and_return(Api::AcademiesApi::Client::Result.new([establishment], nil))
    allow(api_client).to receive(:get_trusts).and_return(Api::AcademiesApi::Client::Result.new([trust], nil))

    allow(api_client).to receive(:get_trust).and_return(Api::AcademiesApi::Client::Result.new(trust, nil))
    allow(api_client).to receive(:get_establishment).and_return(Api::AcademiesApi::Client::Result.new(establishment, nil))

    api_client
  end
end
