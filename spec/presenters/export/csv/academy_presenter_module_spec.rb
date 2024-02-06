require "rails_helper"

RSpec.describe Export::Csv::AcademyPresenterModule do
  let(:project) { build(:conversion_project, academy_urn: 149061, academy: gias_establishment) }
  subject { AcademyPresenterModuleTestClass.new(project) }

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
  end
end
