require "rails_helper"

RSpec.describe Export::Csv::MpPresenterModule do
  let(:project) { build(:conversion_project, establishment: known_establishment) }
  let!(:mp) { create(:member_of_parliament, parliamentary_constituency: "Constituency") }

  subject { MpPresenterModuleTestClass.new(project) }

  it "presents the name" do
    expect(subject.mp_name).to eql "Member Parliament"
  end

  it "presents the email" do
    expect(subject.mp_email).to eql "member.parliament@parliament.uk"
  end

  it "presents the constituency" do
    expect(subject.mp_constituency).to eql "Constituency"
  end

  it "presents the address" do
    expect(subject.mp_address_1).to eql "House of Commons"
    expect(subject.mp_address_2).to eql ""
    expect(subject.mp_address_3).to eql "London"
    expect(subject.mp_address_postcode).to eql "SW1A 0AA"
  end

  it "presents nil values when there is no MP to show" do
    mock_nil_member_for_constituency_response
    mock_all_academies_api_responses

    project = build(:conversion_project)
    presenter = MpPresenterModuleTestClass.new(project)

    expect(presenter.mp_name).to eql nil
    expect(presenter.mp_email).to eql nil
    expect(presenter.mp_constituency).to eql nil
    expect(presenter.mp_address_1).to eql nil
    expect(presenter.mp_address_postcode).to eql nil
  end

  def known_address
    double(
      "MP address",
      line1: "House of Commons",
      line2: "",
      line3: "London",
      postcode: "SW1A 0AA"
    )
  end

  def known_establishment
    double(
      Api::AcademiesApi::Establishment,
      parliamentary_constituency: "Constituency"
    )
  end
end

class MpPresenterModuleTestClass
  include Export::Csv::MpPresenterModule

  def initialize(project)
    @project = project
  end
end
