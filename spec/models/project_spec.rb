require "rails_helper"

RSpec.describe Project, type: :model do
  describe "Columns" do
    it { is_expected.to have_db_column(:urn).of_type :integer }
    it { is_expected.to have_db_column(:trust_ukprn).of_type :integer }
    it { is_expected.to have_db_column(:target_completion_date).of_type :date }
    it { is_expected.to have_db_column(:caseworker_id).of_type :uuid }
    it { is_expected.to have_db_column(:team_leader_id).of_type :uuid }
  end

  describe "Relationships" do
    before { mock_successful_api_responses(urn: any_args, ukprn: any_args) }

    it { is_expected.to have_many(:sections).dependent(:destroy) }
    it { is_expected.to have_many(:notes).dependent(:destroy) }
    it { is_expected.to belong_to(:caseworker).required(false) }
    it { is_expected.to belong_to(:team_leader).required(true) }

    describe "delete related entities" do
      context "when the project is deleted" do
        it "destroys all the related notes, contacts, sections leaving nothing orphaned" do
          project = create(:project)

          create_list(:note, 3, project: project)
          create_list(:contact, 3, project: project)
          create_list(:section, 3, project: project)

          populated_section = project.sections.first
          task = create(:task, section: populated_section)
          create_list(:action, 5, task: task)

          project.destroy

          expect(Note.count).to eql 0
          expect(Contact.count).to eql 0
          expect(Section.count).to eql 0
          expect(Task.count).to eql 0
          expect(Action.count).to eql 0
        end
      end
    end
  end

  describe "Validations" do
    before { mock_successful_api_responses(urn: any_args, ukprn: any_args) }

    describe "#urn" do
      it { is_expected.to validate_presence_of(:urn) }
      it { is_expected.to validate_numericality_of(:urn).only_integer }

      context "when no establishment with that URN exists in the API" do
        let(:no_establishment_found_result) do
          AcademiesApi::Client::Result.new(nil, AcademiesApi::Client::NotFoundError.new("Could not find establishment with URN: 12345"))
        end

        before do
          allow_any_instance_of(AcademiesApi::Client).to \
            receive(:get_establishment) { no_establishment_found_result }
        end

        it "is invalid" do
          expect(subject).to_not be_valid
          expect(subject.errors[:urn]).to include(I18n.t("activerecord.errors.models.project.attributes.urn.no_establishment_found"))
        end
      end
    end

    describe "#trust_ukprn" do
      it { is_expected.to validate_presence_of(:trust_ukprn) }
      it { is_expected.to validate_numericality_of(:trust_ukprn).only_integer }

      context "when no trust with that UKPRN exists in the API" do
        let(:no_trust_found_result) do
          AcademiesApi::Client::Result.new(nil, AcademiesApi::Client::NotFoundError.new("No trust found with that UKPRN. Enter a valid UKPRN."))
        end

        before do
          allow_any_instance_of(AcademiesApi::Client).to \
            receive(:get_trust) { no_trust_found_result }
        end

        it "is invalid" do
          expect(subject).to_not be_valid
          expect(subject.errors[:trust_ukprn]).to include(I18n.t("activerecord.errors.models.project.attributes.trust_ukprn.no_trust_found"))
        end
      end
    end

    describe "#target_completion_date" do
      it { is_expected.to validate_presence_of(:target_completion_date) }

      context "when the date is not on the first of the month" do
        subject { build(:project, target_completion_date: Date.new(2025, 12, 2)) }

        it "is invalid" do
          expect(subject).to_not be_valid
          expect(subject.errors[:target_completion_date]).to include(I18n.t("activerecord.errors.models.project.attributes.target_completion_date.must_be_first_of_the_month"))
        end
      end
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
        mock_successful_api_trust_response(ukprn: 10061021)
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

  describe "#trust" do
    let(:ukprn) { 10061021 }
    let(:trust) { build(:academies_api_trust) }

    subject { described_class.new(trust_ukprn: ukprn) }

    context "when the API returns a successful response" do
      before { mock_successful_api_trust_response(ukprn: ukprn, trust: trust) }

      it "retreives conversion_project data from the Academies API" do
        expect(subject.trust).to eq trust
      end
    end

    context "when the Academies API client returns a #{AcademiesApi::Client::NotFoundError}" do
      let(:error_message) { "Could not find trust for UKPRN 10061021" }
      let(:error) { AcademiesApi::Client::Result.new(nil, AcademiesApi::Client::NotFoundError.new(error_message)) }

      before do
        allow_any_instance_of(AcademiesApi::Client).to \
          receive(:get_trust).with(ukprn) { error }
      end

      it "raises the error" do
        expect { subject.trust }.to raise_error(AcademiesApi::Client::NotFoundError, error_message)
      end
    end

    context "when the Academies API client returns a #{AcademiesApi::Client::Error}" do
      let(:error_message) { "There was an error connecting to the Academies API, could not fetch trust with UKPRN 10061021" }
      let(:error) { AcademiesApi::Client::Result.new(nil, AcademiesApi::Client::Error.new(error_message)) }

      before do
        allow_any_instance_of(AcademiesApi::Client).to \
          receive(:get_trust).with(ukprn) { error }
      end

      it "raises the error" do
        expect { subject.trust }.to raise_error(AcademiesApi::Client::Error, error_message)
      end
    end
  end
end
