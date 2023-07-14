require "rails_helper"

RSpec.describe Export::Csv::LocalAuthorityPresenterModule do
  let(:project) { build(:conversion_project) }
  subject { LocalAuthorityPresenterModuleTestClass.new(project) }

  before do
    allow(project).to receive(:local_authority).and_return known_local_authority
  end

  it "presents the code" do
    expect(subject.local_authority_code).to eql "100"
  end


  it "presents the name" do
    expect(subject.local_authority_name).to eql "West Northamptonshire"
  end

  it "presents the school address" do
    expect(subject.local_authority_address_1).to eql  "1 Angel Square"
    expect(subject.local_authority_address_2).to eql "Angel Street"
    expect(subject.local_authority_address_3).to eql nil
    expect(subject.local_authority_address_town).to eql nil
    expect(subject.local_authority_address_county).to eql "Northampton"
    expect(subject.local_authority_address_postcode).to eql "NN1 1ED"
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
