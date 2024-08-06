require "rails_helper"

RSpec.feature "Users can view a single project group" do
  before do
    mock_academies_api_for_test
    sign_in_with_user(user)
  end

  let(:user) { create(:user, :caseworker) }
  let(:project_group) {
    create(
      :project_group,
      group_identifier: "GRP_12345678",
      trust_ukprn: 12345678
    )
  }
  let!(:local_authority) { create(:local_authority, code: 894) }
  let!(:conversion_project) {
    create(
      :conversion_project,
      urn: 123456,
      group: project_group,
      incoming_trust_ukprn: 12345678
    )
  }
  let!(:transfer_project) {
    create(
      :transfer_project,
      urn: 654321,
      group: project_group,
      incoming_trust_ukprn: 12345678,
      outgoing_trust_ukprn: 18765432
    )
  }

  scenario "they can view the details of the group and it's projects" do
    visit project_group_path(project_group)

    expect(page).to have_content "Group reference number: GRP_12345678"
    expect(page).to have_content "Trust reference number: TR100610"
    expect(page).to have_content "Number in group: 2"

    within ".govuk-summary-card:first-of-type" do
      expect(page).to have_content "123456"
      expect(page).to have_content "Cumbria County Council"
      expect(page).to have_content "West Midlands"
      expect(page).to have_content "Conversion"
    end

    within ".govuk-summary-card:last-of-type" do
      expect(page).to have_content "654321"
      expect(page).to have_content "Cumbria County Council"
      expect(page).to have_content "West Midlands"
      expect(page).to have_content "Transfer"
    end
  end

  scenario "they can navigate from project to group and back again" do
    visit project_path(conversion_project)
    click_on "About the project"
    click_on "GRP_12345678"

    expect(current_url).to include project_group.id
    expect(page).to have_content "Converting establishment"
    expect(page).to have_content "Transferring establishment"

    click_on "Transferring establishment"

    expect(current_url).to include transfer_project.id
    expect(page).to have_content "In a group"
  end

  def mock_academies_api_for_test
    converting_establishment = build(:academies_api_establishment, urn: 123456, name: "Converting establishment")
    transferring_establishment = build(:academies_api_establishment, urn: 654321, name: "Transferring establishment")
    trust = build(:academies_api_trust, ukprn: 12345678)

    establishments = [converting_establishment, transferring_establishment]
    trusts = [trust]

    fake_client = double(Api::AcademiesApi::Client)

    allow(fake_client).to receive(:get_establishment).with(123456).and_return(
      Api::AcademiesApi::Client::Result.new(converting_establishment, nil)
    )
    allow(fake_client).to receive(:get_establishment).with(654321).and_return(
      Api::AcademiesApi::Client::Result.new(transferring_establishment, nil)
    )
    allow(fake_client).to receive(:get_establishments).and_return(
      Api::AcademiesApi::Client::Result.new(establishments, nil)
    )
    allow(fake_client).to receive(:get_trusts).and_return(
      Api::AcademiesApi::Client::Result.new(trusts, nil)
    )
    allow(fake_client).to receive(:get_trust).with(12345678).and_return(
      Api::AcademiesApi::Client::Result.new(trust, nil)
    )
    allow(fake_client).to receive(:get_trust).with(18765432).and_return(
      Api::AcademiesApi::Client::Result.new(trust, nil)
    )

    allow(Api::AcademiesApi::Client).to receive(:new).and_return(fake_client)
  end
end
