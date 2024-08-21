require "rails_helper"

RSpec.describe Export::Csv::MpPresenterModule, skip: "Waiting for Person API" do
  before do
    mock_all_academies_api_responses
    allow(project.establishment).to receive(:parliamentary_constituency).and_return("Constituency Name")
  end

  let(:project) do
    build(:conversion_project)
  end

  subject { MpPresenterModuleTestClass.new(project) }

  context "when there is a member" do
    before { mock_successful_persons_api_client }

    it "presents the name" do
      expect(subject.mp_name).to eql "First Last"
    end

    it "presents the email" do
      expect(subject.mp_email).to eql "lastf@parliament.gov.uk"
    end

    it "presents the constituency" do
      expect(subject.mp_constituency).to eql "Constituency Name"
    end

    it "presents the address" do
      expect(subject.mp_address_1).to eql "House of Commons"
      expect(subject.mp_address_2).to eql "London"
      expect(subject.mp_address_3).to eql ""
      expect(subject.mp_address_postcode).to eql "SW1A 0AA"
    end
  end

  context "when there is not a member" do
    before { mock_failed_persons_api_client }

    it "presents nil values when there is no MP to show" do
      mock_all_academies_api_responses

      project = build(:conversion_project)
      presenter = MpPresenterModuleTestClass.new(project)

      expect(presenter.mp_name).to eql nil
      expect(presenter.mp_email).to eql nil
      expect(presenter.mp_constituency).to eql nil
      expect(presenter.mp_address_1).to eql nil
      expect(presenter.mp_address_2).to eql nil
      expect(presenter.mp_address_3).to eql nil
      expect(presenter.mp_address_postcode).to eql nil
    end
  end
end

class MpPresenterModuleTestClass
  include Export::Csv::MpPresenterModule

  def initialize(project)
    @project = project
  end
end
