require "rails_helper"

RSpec.describe Export::Csv::OutgoingTrustPresenterModule do
  let(:outgoing_trust_main_contact) do
    mock_successful_api_response_to_create_any_project
    create(:project_contact, category: "outgoing_trust")
  end
  let(:project) { build(:transfer_project, outgoing_trust_ukprn: 121813, outgoing_trust_main_contact_id: outgoing_trust_main_contact.id) }
  subject { OutgoingTrustPresenterModuleTestClass.new(project) }

  before do
    allow(project).to receive(:outgoing_trust).and_return(known_trust)
  end

  it "presents the ukprn" do
    expect(subject.outgoing_trust_ukprn).to eql "121813"
  end

  it "presents the companies house number" do
    expect(subject.outgoing_trust_companies_house_number).to eql "10768218"
  end

  it "presents the name" do
    expect(subject.outgoing_trust_name).to eql "The Grand Union Partnership"
  end

  it "presents the main contact name" do
    expect(subject.outgoing_trust_main_contact_name).to eql "Jo Example"
  end

  it "presents the main contact email" do
    expect(subject.outgoing_trust_main_contact_email).to eql "jo@example.com"
  end

  def known_trust
    double(
      Api::AcademiesApi::Trust,
      ukprn: 10066123,
      companies_house_number: 10768218,
      group_identifier: "TR03819",
      name: "The Grand Union Partnership",
      address_street: "New Bradwell County Combined School",
      address_locality: "Bounty Street",
      address_additional: nil,
      address_town: "Milton Keynes",
      address_county: nil,
      address_postcode: "MK13 0BQ"
    )
  end
end

class OutgoingTrustPresenterModuleTestClass
  include Export::Csv::OutgoingTrustPresenterModule

  def initialize(project)
    @project = project
  end
end
