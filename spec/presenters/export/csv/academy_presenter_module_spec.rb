require "rails_helper"

RSpec.describe Export::Csv::AcademyPresenterModule do
  context "when a project is a conversion project" do
    let(:project) { build(:conversion_project, academy_urn: 149061, academy: gias_establishment) }
    subject { AcademyPresenterModuleTestClass.new(project) }

    before { mock_successful_api_response_to_create_any_project }

    it "presents the academy urn" do
      expect(subject.academy_urn).to eql "149061"
    end

    it "presents the academy ukprn" do
      expect(subject.academy_ukprn).to eql "10065250"
    end

    it "presents the academy DfE number" do
      expect(subject.academy_dfe_number).to eql "941/2025"
    end

    it "presents the academy name" do
      expect(subject.academy_name).to eql "Deanshanger Primary School"
    end

    it "presents the academy type" do
      expect(subject.academy_type).to eql "Academy converter"
    end

    it "presents the academy address" do
      expect(subject.academy_address_1).to eql "The Green"
      expect(subject.academy_address_2).to eql "Deanshanger"
      expect(subject.academy_address_3).to eql "Deanshanger Primary School, the Green, Deanshanger"
      expect(subject.academy_address_town).to eql "Milton Keynes"
      expect(subject.academy_address_county).to eql "Buckinghamshire"
      expect(subject.academy_address_postcode).to eql "MK19 6HJ"
    end

    context "when the project has more than one school or academy contact" do
      it "presents the academy contact names" do
        mock_successful_api_response_to_create_any_project
        create(:project_contact, category: "school_or_academy", name: "academy contact name", project: project)
        create(:establishment_contact, establishment_urn: project.urn, name: "establishment contact name")

        expect(subject.academy_contact_name).to eql("academy contact name,establishment contact name")
      end

      it "presents the academy contact emails" do
        mock_successful_api_response_to_create_any_project
        create(:project_contact, category: "school_or_academy", email: "academy_contact@email.com", project: project)
        create(:establishment_contact, establishment_urn: project.urn, email: "establishment_contact@email.com")

        expect(subject.academy_contact_email).to eql("academy_contact@email.com,establishment_contact@email.com")
      end
    end
  end

  context "when a project is a transfer project" do
    let(:transfer_project) { build(:transfer_project, urn: 123456) }
    subject { AcademyPresenterModuleTestClass.new(transfer_project) }

    it "presents the academy contact name" do
      mock_successful_api_response_to_create_any_project
      create(:project_contact, category: "school_or_academy", name: "academy contact name", project: transfer_project)

      expect(subject.academy_contact_name).to eql("academy contact name")
    end

    it "presents the academy contact email" do
      mock_successful_api_response_to_create_any_project
      create(:project_contact, category: "school_or_academy", email: "academy_contact@email.com", project: transfer_project)

      expect(subject.academy_contact_email).to eql("academy_contact@email.com")
    end
  end

  def gias_establishment
    build(:gias_establishment,
      urn: 149061,
      ukprn: 10065250,
      name: "Deanshanger Primary School",
      establishment_number: "2025",
      local_authority_code: "941",
      type: "Academy converter",
      address_street: "The Green",
      address_locality: "Deanshanger",
      address_additional: "Deanshanger Primary School, the Green, Deanshanger",
      address_town: "Milton Keynes",
      address_county: "Buckinghamshire",
      address_postcode: "MK19 6HJ")
  end
end

class AcademyPresenterModuleTestClass
  include Export::Csv::AcademyPresenterModule

  def initialize(project)
    @project = project
    @contacts_fetcher = ContactsFetcherService.new(@project)
    @academy = @project.academy if @project.academy_urn.present?
  end
end
