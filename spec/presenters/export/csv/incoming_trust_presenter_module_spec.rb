require "rails_helper"

RSpec.describe Export::Csv::IncomingTrustPresenterModule do
  let(:incoming_trust_main_contact) do
    mock_successful_api_response_to_create_any_project
    create(:project_contact, category: "incoming_trust")
  end
  let(:project) { build(:conversion_project, incoming_trust_ukprn: 121813, incoming_trust: known_trust, incoming_trust_main_contact_id: incoming_trust_main_contact.id) }
  subject { IncomingTrustPresenterModuleTestClass.new(project) }

  it "presents the identifier" do
    expect(subject.incoming_trust_identifier).to eql "TR03819"
  end

  it "presents the ukprn" do
    expect(subject.incoming_trust_ukprn).to eql "121813"
  end

  it "presents the companies house number" do
    expect(subject.incoming_trust_companies_house_number).to eql "10768218"
  end

  it "presents the name" do
    expect(subject.incoming_trust_name).to eql "The Grand Union Partnership"
  end

  it "presents the school address" do
    expect(subject.incoming_trust_address_1).to eql "New Bradwell County Combined School"
    expect(subject.incoming_trust_address_2).to eql "Bounty Street"
    expect(subject.incoming_trust_address_3).to be_nil
    expect(subject.incoming_trust_address_town).to eql "Milton Keynes"
    expect(subject.incoming_trust_address_county).to be_nil
    expect(subject.incoming_trust_address_postcode).to eql "MK13 0BQ"
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

  it "presents the main contact name" do
    expect(subject.incoming_trust_main_contact_name).to eql "Jo Example"
  end

  it "presents the main contact email" do
    expect(subject.incoming_trust_main_contact_email).to eql "jo@example.com"
  end

  it "presents the sharepoint link" do
    expect(subject.incoming_trust_sharepoint_link).to eql "https://educationgovuk-my.sharepoint.com/incoming-trust-folder"
  end
end

class IncomingTrustPresenterModuleTestClass
  include Export::Csv::IncomingTrustPresenterModule

  def initialize(project)
    @project = project
  end
end
