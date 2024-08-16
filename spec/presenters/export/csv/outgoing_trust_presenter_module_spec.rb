require "rails_helper"

RSpec.describe Export::Csv::OutgoingTrustPresenterModule do
  let(:project) { create(:transfer_project, outgoing_trust_ukprn: 12345678) }
  let(:outgoing_trust_main_contact) { create(:project_contact, category: "outgoing_trust", project: project) }
  subject { OutgoingTrustPresenterModuleTestClass.new(project) }

  before do
    mock_successful_api_response_to_create_any_project
    allow(project).to receive(:outgoing_trust_main_contact_id).and_return(outgoing_trust_main_contact.id)
    allow(project).to receive(:outgoing_trust).and_return(known_trust)
  end

  it "presents the ukprn" do
    expect(subject.outgoing_trust_ukprn).to eql "12345678"
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

  it "presents the outgoing trust identifier" do
    expect(subject.outgoing_trust_identifier).to eql "TR03819"
  end

  it "presents the outgoing trusts address" do
    expect(subject.outgoing_trust_address_1).to eql "New Bradwell County Combined School"
    expect(subject.outgoing_trust_address_2).to eql "Bounty Street"
    expect(subject.outgoing_trust_address_3).to be_nil
    expect(subject.outgoing_trust_address_town).to eql "Milton Keynes"
    expect(subject.outgoing_trust_address_county).to be_nil
    expect(subject.outgoing_trust_address_postcode).to eql "MK13 0BQ"
  end

  it "presents the sharepoint link" do
    expect(subject.outgoing_trust_sharepoint_link).to eql "https://educationgovuk-my.sharepoint.com/outgoing-trust-folder"
  end

  describe "outgoing trust CEO contact" do
    context "when there is a contact" do
      it "presents the contact details" do
        contact = create(:project_contact)
        KeyContacts.new(project: project, outgoing_trust_ceo: contact)

        expect(subject.outgoing_trust_ceo_contact_name).to eql "Jo Example"
        expect(subject.outgoing_trust_ceo_contact_role).to eql "CEO of Learning"
        expect(subject.outgoing_trust_ceo_contact_email).to eql "jo@example.com"
      end
    end

    context "when there is no contact" do
      it "presents nothing" do
        expect(subject.outgoing_trust_ceo_contact_name).to be_nil
        expect(subject.outgoing_trust_ceo_contact_role).to be_nil
        expect(subject.outgoing_trust_ceo_contact_email).to be_nil
      end
    end
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
    @contacts_fetcher = ContactsFetcherService.new(@project)
  end
end
