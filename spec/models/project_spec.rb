require "rails_helper"

RSpec.describe Project, type: :model do
  describe "Columns" do
    it { is_expected.to have_db_column(:urn).of_type :integer }
  end

  describe "Validations" do
    before { mock_successful_api_establishment_response(urn: any_args) }

    describe "#urn" do
      it { is_expected.to validate_presence_of(:urn) }
      it { is_expected.to validate_numericality_of(:urn).only_integer }

      context "when no establishment with that URN exists in the API" do
        let(:establishment_result) do
          AcademiesApi::Client::Result.new(nil, AcademiesApi::Client::NotFoundError.new("Could not find establishment with URN: 12345"))
        end

        before do
          allow_any_instance_of(AcademiesApi::Client).to \
            receive(:get_establishment) { establishment_result }
        end

        it "is invalid" do
          expect(subject).to_not be_valid
          subject.errors[:urn].include?("No establishment exists with that URN. Enter a valid URN.")
        end
      end
    end
  end

  describe "Relationships" do
    it { is_expected.to have_many(:sections).dependent(:destroy) }
  end

  describe "#establishment" do
    let(:urn) { 12345 }
    let(:establishment) { build(:academies_api_establishment) }

    subject { described_class.new(urn: urn) }

    context "when the API returns a successful response" do
      before { mock_successful_api_establishment_response(urn: urn, establishment:) }

      it "retreives establishment data from the Academies API" do
        expect(subject.establishment).to eq establishment
      end
    end

    context "when the Academies API client returns a #{AcademiesApi::Client::NotFoundError}" do
      let(:error_message) { "Could not find establishment with URN: 12345" }
      let(:error) { AcademiesApi::Client::Result.new(nil, AcademiesApi::Client::NotFoundError.new(error_message)) }

      before do
        allow_any_instance_of(AcademiesApi::Client).to \
          receive(:get_establishment).with(urn) { error }
      end

      it "raises the error" do
        expect { subject.establishment }.to raise_error(AcademiesApi::Client::NotFoundError, error_message)
      end
    end

    context "when the Academies API client returns a #{AcademiesApi::Client::Error}" do
      let(:error_message) { "There was an error connecting to the Academies API, could not fetch establishment for URN: 12345" }
      let(:error) { AcademiesApi::Client::Result.new(nil, AcademiesApi::Client::Error.new(error_message)) }

      before do
        allow_any_instance_of(AcademiesApi::Client).to \
          receive(:get_establishment).with(urn) { error }
      end

      it "raises the error" do
        expect { subject.establishment }.to raise_error(AcademiesApi::Client::Error, error_message)
      end
    end
  end

  describe "#conversion_project" do
    let(:urn) { 12345 }
    let(:conversion_project) { build(:academies_api_conversion_project) }

    subject { described_class.new(urn: urn) }

    context "when the API returns a successful response" do
      before { mock_successful_api_conversion_project_response(urn: urn, conversion_project:) }

      it "retreives conversion_project data from the Academies API" do
        expect(subject.conversion_project).to eq conversion_project
      end
    end

    context "when the Academies API client returns a #{AcademiesApi::Client::NotFoundError}" do
      let(:error_message) { "Could not find conversion project with URN: 12345" }
      let(:error) { AcademiesApi::Client::Result.new(nil, AcademiesApi::Client::NotFoundError.new(error_message)) }

      before do
        allow_any_instance_of(AcademiesApi::Client).to \
          receive(:get_conversion_project).with(urn) { error }
      end

      it "raises the error" do
        expect { subject.conversion_project }.to raise_error(AcademiesApi::Client::NotFoundError, error_message)
      end
    end

    context "when the Academies API client returns a #{AcademiesApi::Client::Error}" do
      let(:error_message) { "There was an error connecting to the Academies API, could not fetch conversion project for URN: 12345" }
      let(:error) { AcademiesApi::Client::Result.new(nil, AcademiesApi::Client::Error.new(error_message)) }

      before do
        allow_any_instance_of(AcademiesApi::Client).to \
          receive(:get_conversion_project).with(urn) { error }
      end

      it "raises the error" do
        expect { subject.conversion_project }.to raise_error(AcademiesApi::Client::Error, error_message)
      end
    end
  end
end
