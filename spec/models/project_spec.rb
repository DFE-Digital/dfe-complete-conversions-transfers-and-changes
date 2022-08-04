require "rails_helper"

RSpec.describe Project, type: :model do
  describe "Columns" do
    it { is_expected.to have_db_column(:urn).of_type :integer }
    it { is_expected.to have_db_column(:trust_ukprn).of_type :integer }
    it { is_expected.to have_db_column(:delivery_officer_id).of_type :uuid }
    it { is_expected.to have_db_column(:team_leader_id).of_type :uuid }
  end

  describe "Relationships" do
    before { mock_successful_api_responses(urn: any_args) }

    it { is_expected.to have_many(:sections).dependent(:destroy) }
    it { is_expected.to belong_to(:delivery_officer).required(false) }
    it { is_expected.to belong_to(:team_leader).required(true) }
  end

  describe "Validations" do
    before { mock_successful_api_responses(urn: any_args) }

    describe "#urn" do
      it { is_expected.to validate_presence_of(:urn) }
      it { is_expected.to validate_numericality_of(:urn).only_integer }

      context "when no establishment with that URN exists in the API" do
        let(:establishment_result) do
          AcademiesApi::Client::Result.new(nil, AcademiesApi::Client::NotFoundError.new("Could not find establishment with URN: 12345"))
        end

        before do
          mock_successful_api_conversion_project_response(urn: 12345)
          allow_any_instance_of(AcademiesApi::Client).to \
            receive(:get_establishment) { establishment_result }
        end

        it "is invalid" do
          expect(subject).to_not be_valid
          expect(subject.errors[:urn]).to include(I18n.t("activerecord.errors.models.project.no_establishment_found"))
        end
      end

      context "when no conversion project with that URN exists in the API" do
        let(:conversion_project_result) do
          AcademiesApi::Client::Result.new(nil, AcademiesApi::Client::NotFoundError.new(I18n.t("academies_api.get_conversion_project.errors.not_found", urn: 12345)))
        end

        before do
          mock_successful_api_establishment_response(urn: 12345)
          allow_any_instance_of(AcademiesApi::Client).to \
            receive(:get_conversion_project) { conversion_project_result }
        end

        it "is invalid" do
          expect(subject).to_not be_valid
          expect(subject.errors[:urn]).to include(I18n.t("activerecord.errors.models.project.no_conversion_project_found"))
        end
      end

      context "when multiple conversion projects with that URN exist in the API" do
        let(:conversion_project_result) do
          AcademiesApi::Client::Result.new(nil, AcademiesApi::Client::MultipleResultsError.new(I18n.t("academies_api.get_conversion_project.errors.multiple_results", urn: 12345, record_count: 2)))
        end

        before do
          mock_successful_api_establishment_response(urn: 12345)
          allow_any_instance_of(AcademiesApi::Client).to \
            receive(:get_conversion_project) { conversion_project_result }
        end

        it "is invalid" do
          expect(subject).to_not be_valid
          expect(subject.errors[:urn]).to include(I18n.t("activerecord.errors.models.project.multiple_conversion_projects_found"))
        end
      end
    end

    describe "#trust_ukprn" do
      it { is_expected.to validate_presence_of(:trust_ukprn) }
    end

    describe "#team_leader" do
      it { is_expected.to validate_presence_of(:team_leader) }
    end
  end

  describe "#establishment" do
    let(:urn) { 12345 }
    let(:establishment) { build(:academies_api_establishment) }

    subject { described_class.new(urn: urn) }

    context "when the API returns a successful response" do
      before do
        mock_successful_api_establishment_response(urn: urn, establishment:)
        mock_successful_api_conversion_project_response(urn: urn)
      end

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
