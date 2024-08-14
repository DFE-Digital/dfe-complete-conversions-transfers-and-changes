require "rails_helper"

RSpec.describe Export::Csv::SchoolPresenterModule do
  let(:project) { create(:conversion_project, urn: 121813, establishment: known_establishment) }
  let(:contact) { create(:project_contact, category: "school_or_academy", project: project) }
  let(:director_of_child_services) { build(:director_of_child_services) }
  subject { SchoolPresenterModuleTestClass.new(project) }

  before do
    mock_successful_api_response_to_create_any_project
    allow(project).to receive(:establishment_main_contact_id).and_return(contact.id)
    allow(project).to receive(:director_of_child_services).and_return(director_of_child_services)
  end

  it "presents the school urn" do
    expect(subject.school_urn).to eql "121813"
  end

  it "presents the school DfE number" do
    expect(subject.school_dfe_number).to eql "941/2025"
  end

  it "presents the school name" do
    expect(subject.school_name).to eql "Deanshanger Primary School"
  end

  it "presents the school type" do
    expect(subject.school_type).to eql "Community school"
  end

  it "presents the school phase" do
    expect(subject.school_phase).to eql "Secondary"
  end

  context "when a school is a PRU or special school and has a school phase of Not applicable" do
    let(:project) { create(:conversion_project, establishment: special_establishment) }
    subject { SchoolPresenterModuleTestClass.new(project) }

    it "presents the school type instead" do
      expect(subject.school_phase).to eql "Community school"
    end
  end

  it "presents the school age range" do
    expect(subject.school_age_range).to eql "5 - 16"
  end

  it "presents the school address" do
    expect(subject.school_address_1).to eql "The Green"
    expect(subject.school_address_2).to eql "Deanshanger"
    expect(subject.school_address_3).to eql "Deanshanger Primary School, the Green, Deanshanger"
    expect(subject.school_address_town).to eql "Milton Keynes"
    expect(subject.school_address_county).to eql "Buckinghamshire"
    expect(subject.school_address_postcode).to eql "MK19 6HJ"
  end

  it "presents the school sharepoint folder link" do
    expect(subject.school_sharepoint_folder).to eql "https://educationgovuk-my.sharepoint.com/establishment-folder"
  end

  context "when a school method has an alternative label" do
    it "presents the project URN" do
      expect(subject.school_urn_with_academy_label).to eql "121813"
    end

    it "presents the academy sharepoint link" do
      expect(subject.school_sharepoint_link_with_academy_label).to eql "https://educationgovuk-my.sharepoint.com/establishment-folder"
    end

    it "presents the academy type" do
      expect(subject.school_type_with_academy_label).to eql "Community school"
    end

    it "presents the academy address" do
      expect(subject.school_address_1_with_academy_label).to eql "The Green"
      expect(subject.school_address_2_with_academy_label).to eql "Deanshanger"
      expect(subject.school_address_3_with_academy_label).to eql "Deanshanger Primary School, the Green, Deanshanger"
      expect(subject.school_address_town_with_academy_label).to eql "Milton Keynes"
      expect(subject.school_address_county_with_academy_label).to eql "Buckinghamshire"
      expect(subject.school_address_postcode_with_academy_label).to eql "MK19 6HJ"
    end

    it "presents the academy name" do
      expect(subject.school_name_with_academy_label).to eql "Deanshanger Primary School"
    end
  end

  it "presents the school main contact name" do
    expect(subject.school_main_contact_name).to eq("Jo Example")
  end

  it "presents the school main contact email" do
    expect(subject.school_main_contact_email).to eq("jo@example.com")
  end

  it "presents the school main contact role" do
    expect(subject.school_main_contact_role).to eq("CEO of Learning")
  end

  context "when the school main contact is a Contact::Establishment" do
    let(:contact) { create(:establishment_contact, email: "headteacher@school.com", establishment_urn: project.urn) }

    it "presents the school main contact email" do
      expect(subject.school_main_contact_email).to eq("headteacher@school.com")
    end
  end

  describe "headteacher contact" do
    context "when the headteacher contact is confirmed" do
      it "shows the contact details" do
        KeyContacts.new(project: project, headteacher: contact)

        expect(subject.headteacher_contact_name).to eql "Jo Example"
        expect(subject.headteacher_contact_role).to eql "CEO of Learning"
        expect(subject.headteacher_contact_email).to eql "jo@example.com"
      end
    end

    context "when the headteacher contact is not confirmed" do
      it "shows nothing" do
        expect(subject.headteacher_contact_name).to be_nil
        expect(subject.headteacher_contact_role).to be_nil
        expect(subject.headteacher_contact_email).to be_nil
      end
    end
  end

  def known_establishment
    double(
      Api::AcademiesApi::Establishment,
      urn: 121813,
      name: "Deanshanger Primary School",
      phase: "Secondary",
      dfe_number: "941/2025",
      type: "Community school",
      address_street: "The Green",
      address_locality: "Deanshanger",
      address_additional: "Deanshanger Primary School, the Green, Deanshanger",
      address_town: "Milton Keynes",
      address_county: "Buckinghamshire",
      address_postcode: "MK19 6HJ",
      age_range_lower: 5,
      age_range_upper: 16
    )
  end

  def special_establishment
    double(
      Api::AcademiesApi::Establishment,
      phase: "Not applicable",
      type: "Community school"
    )
  end
end

class SchoolPresenterModuleTestClass
  include Export::Csv::SchoolPresenterModule

  def initialize(project)
    @project = project
    @contacts_fetcher = ContactsFetcherService.new(@project)
  end
end
