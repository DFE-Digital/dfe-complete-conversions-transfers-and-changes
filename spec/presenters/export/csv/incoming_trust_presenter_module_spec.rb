require "rails_helper"

RSpec.describe Export::Csv::IncomingTrustPresenterModule do
  let(:project) { create(:conversion_project, incoming_trust_ukprn: 12345678, incoming_trust: known_trust) }
  let(:incoming_trust_main_contact) { create(:project_contact, category: "incoming_trust", project: project) }
  subject { IncomingTrustPresenterModuleTestClass.new(project) }

  before do
    mock_successful_api_response_to_create_any_project
    allow(project).to receive(:incoming_trust_main_contact_id).and_return(incoming_trust_main_contact.id)
  end

  it "presents the identifier" do
    expect(subject.incoming_trust_identifier).to eql "TR03819"
  end

  context "when the project is a form a MAT project" do
    let(:project) { build(:conversion_project, :form_a_mat) }

    it "presents the identifier" do
      expect(subject.incoming_trust_identifier).to eql "TR12345"
    end
  end

  it "presents the ukprn" do
    expect(subject.incoming_trust_ukprn).to eql "12345678"
  end

  context "when there is no incoming_trust_ukprn" do
    let(:project) { create(:conversion_project, :form_a_mat) }

    it "returns nil for the incoming_trust_ukprn" do
      expect(subject.incoming_trust_ukprn).to be_nil
    end
  end

  it "presents the companies house number" do
    expect(subject.incoming_trust_companies_house_number).to eql "10768218"
  end

  context "when the project is a form a MAT project" do
    let(:project) { create(:conversion_project, :form_a_mat) }

    it "returns nil for the companies house number" do
      expect(subject.incoming_trust_companies_house_number).to eq("")
    end
  end

  it "presents the name" do
    expect(subject.incoming_trust_name).to eql "The Grand Union Partnership"
  end

  context "when the project is a form a MAT project" do
    let(:project) { create(:conversion_project, :form_a_mat, new_trust_name: "New Trust") }

    it "returns the new trust name" do
      expect(subject.incoming_trust_name).to eq("New Trust")
    end
  end

  it "presents the school address" do
    expect(subject.incoming_trust_address_1).to eql "New Bradwell County Combined School"
    expect(subject.incoming_trust_address_2).to eql "Bounty Street"
    expect(subject.incoming_trust_address_3).to be_nil
    expect(subject.incoming_trust_address_town).to eql "Milton Keynes"
    expect(subject.incoming_trust_address_county).to be_nil
    expect(subject.incoming_trust_address_postcode).to eql "MK13 0BQ"
  end

  it "presents the main contact name" do
    expect(subject.incoming_trust_main_contact_name).to eql "Jo Example"
  end

  it "presents the main contact email" do
    expect(subject.incoming_trust_main_contact_email).to eql "jo@example.com"
  end

  it "presents the main contact role" do
    expect(subject.incoming_trust_main_contact_role).to eql "CEO of Learning"
  end

  it "presents the sharepoint link" do
    expect(subject.incoming_trust_sharepoint_link).to eql "https://educationgovuk-my.sharepoint.com/incoming-trust-folder"
  end

  describe "incoming trust ceo contact" do
    context "when there is a confirmed contact" do
      let(:contact) { create(:project_contact) }

      it "shows the correct details" do
        KeyContacts.new(project: project, incoming_trust_ceo: contact)

        expect(subject.incoming_trust_ceo_contact_name).to eql contact.name
        expect(subject.incoming_trust_ceo_contact_role).to eql contact.title
        expect(subject.incoming_trust_ceo_contact_email).to eql contact.email
      end
    end
    context "when there is no confirmed contact" do
      it "shows nothing" do
        expect(subject.incoming_trust_ceo_contact_name).to be_nil
        expect(subject.incoming_trust_ceo_contact_role).to be_nil
        expect(subject.incoming_trust_ceo_contact_email).to be_nil
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

class IncomingTrustPresenterModuleTestClass
  include Export::Csv::IncomingTrustPresenterModule

  def initialize(project)
    @project = project
    @contacts_fetcher = ContactsFetcherService.new(@project)
  end
end
