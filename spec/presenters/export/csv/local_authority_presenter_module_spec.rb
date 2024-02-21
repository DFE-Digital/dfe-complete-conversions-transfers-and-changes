require "rails_helper"

RSpec.describe Export::Csv::LocalAuthorityPresenterModule do
  before do
    mock_successful_api_response_to_create_any_project
    allow(project).to receive(:local_authority).and_return known_local_authority
    allow(project).to receive(:director_of_child_services).and_return(director_of_child_services_contact)
  end

  let(:project) { create(:conversion_project) }
  let(:director_of_child_services_contact) { create(:director_of_child_services, name: "Jake Example") }

  subject { LocalAuthorityPresenterModuleTestClass.new(project) }

  it "presents the code" do
    expect(subject.local_authority_code).to eql "100"
  end

  it "presents the name" do
    expect(subject.local_authority_name).to eql "West Northamptonshire"
  end

  it "presents the school address" do
    expect(subject.local_authority_address_1).to eql "1 Angel Square"
    expect(subject.local_authority_address_2).to eql "Angel Street"
    expect(subject.local_authority_address_3).to eql nil
    expect(subject.local_authority_address_town).to eql nil
    expect(subject.local_authority_address_county).to eql "Northampton"
    expect(subject.local_authority_address_postcode).to eql "NN1 1ED"
  end

  it "presents the local authority contact name" do
    expect(subject.local_authority_contact_name).to eql "Jake Example"
  end

  it "presents the local authority contact email" do
    expect(subject.local_authority_contact_email).to eql "jake@example.com"
  end

  context "when there is more than one local authority contact" do
    let!(:local_authority_main_contact) { create(:project_contact, category: "local_authority", name: "Bob Contact", email: "local_authority_contact@email.com", project: project) }

    it "presents the local authority contact names" do
      expect(subject.local_authority_contact_name).to eql "Bob Contact,Jake Example"
    end

    it "presents the local authority contact emails" do
      expect(subject.local_authority_contact_email).to eql "local_authority_contact@email.com,jake@example.com"
    end
  end

  def known_local_authority
    double(
      LocalAuthority,
      code: 100,
      name: "West Northamptonshire",
      address_1: "1 Angel Square",
      address_2: "Angel Street",
      address_3: nil,
      address_town: nil,
      address_county: "Northampton",
      address_postcode: "NN1 1ED"
    )
  end
end

class LocalAuthorityPresenterModuleTestClass
  include Export::Csv::LocalAuthorityPresenterModule

  def initialize(project)
    @project = project
  end
end
