require "rails_helper"

RSpec.describe Project, type: :model do
  describe "Columns" do
    it { is_expected.to have_db_column(:urn).of_type :integer }
  end

  describe "Validations" do
    it "urn" do
      is_expected.to validate_presence_of(:urn)
      is_expected.to validate_numericality_of(:urn).only_integer
    end
  end

  describe "Relationships" do
    it { is_expected.to have_many(:sections) }
  end

  describe "#establishment" do
    let(:urn) { 12345 }
    let(:establishment) { build(:academies_api_establishment) }
    let(:establishment_result) { AcademiesApi::Client::Result.new(establishment, nil) }

    subject { described_class.new(urn:) }

    before do
      allow_any_instance_of(AcademiesApi::Client).to \
        receive(:get_establishment).with(urn) { establishment_result }
    end

    it "retreives establishment data from the Academies API" do
      expect(subject.establishment).to be establishment
    end

    context "when the Academies API client returns a #{AcademiesApi::Client::NotFoundError}" do
      let(:error_message) { "Could not find establishment with URN: 12345" }
      let(:establishment_result) { AcademiesApi::Client::Result.new(nil, AcademiesApi::Client::NotFoundError.new(error_message)) }

      it "raises the error" do
        expect { subject.establishment }.to raise_error(AcademiesApi::Client::NotFoundError, error_message)
      end
    end

    context "when the Academies API client returns a #{AcademiesApi::Client::Error}" do
      let(:error_message) { "There was an error connecting to the Academies API, could not fetch establishment for URN: 12345" }
      let(:establishment_result) { AcademiesApi::Client::Result.new(nil, AcademiesApi::Client::Error.new(error_message)) }

      it "raises the error" do
        expect { subject.establishment }.to raise_error(AcademiesApi::Client::Error, error_message)
      end
    end
  end
end
