require "rails_helper"

RSpec.describe Project, type: :model do
  describe "Columns" do
    it { is_expected.to have_db_column(:urn).of_type :integer }
    it { is_expected.to have_db_column(:incoming_trust_ukprn).of_type :integer }
    it { is_expected.to have_db_column(:target_completion_date).of_type :date }
    it { is_expected.to have_db_column(:caseworker_id).of_type :uuid }
    it { is_expected.to have_db_column(:team_leader_id).of_type :uuid }
    it { is_expected.to have_db_column(:caseworker_assigned_at).of_type :datetime }
    it { is_expected.to have_db_column(:advisory_board_date).of_type :date }
    it { is_expected.to have_db_column(:advisory_board_conditions).of_type :text }
  end

  describe "Relationships" do
    before { mock_successful_api_responses(urn: any_args, ukprn: any_args) }

    it { is_expected.to have_many(:sections).dependent(:destroy) }
    it { is_expected.to have_many(:notes).dependent(:destroy) }
    it { is_expected.to belong_to(:caseworker).required(false) }
    it { is_expected.to belong_to(:team_leader).required(false) }

    describe "accept nested attributes for note" do
      let(:user) { create(:user) }
      let(:note_attributes) { attributes_for(:note, body: note_body, project: nil, user: user) }
      let(:project_attributes) { attributes_for(:project) }

      before { Project.create!(**project_attributes, notes_attributes: [note_attributes]) }

      context "when the note body is blank" do
        let(:note_body) { nil }

        it "does not save the note" do
          expect(Note.count).to be 0
        end
      end

      context "when the note body is not blank" do
        let(:note_body) { "A new note" }

        it "saves the note" do
          expect(Note.count).to be 1
          expect(Note.last.body).to eq note_body
        end
      end
    end

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

    it { is_expected.to validate_presence_of(:advisory_board_date).on(:create) }

    describe "#urn" do
      it { is_expected.to validate_presence_of(:urn) }
      it { is_expected.to validate_numericality_of(:urn).only_integer }
      it { is_expected.to allow_value(123456).for(:urn) }
      it { is_expected.not_to allow_values(12345, 1234567).for(:urn) }

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

    describe "#incoming_trust_ukprn" do
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
          expect(subject.errors[:incoming_trust_ukprn]).to include(I18n.t("activerecord.errors.models.project.attributes.incoming_trust_ukprn.no_trust_found"))
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

      context "when date is today" do
        subject { build(:project, target_completion_date: Date.today) }

        it "is invalid" do
          expect(subject).to_not be_valid
          expect(subject.errors[:target_completion_date]).to include(I18n.t("activerecord.errors.models.project.attributes.target_completion_date.must_be_in_the_future"))
        end
      end

      context "when date is in the past" do
        subject { build(:project, target_completion_date: Date.yesterday) }

        it "is invalid" do
          expect(subject).to_not be_valid
          expect(subject.errors[:target_completion_date]).to include(I18n.t("activerecord.errors.models.project.attributes.target_completion_date.must_be_in_the_future"))
        end
      end
    end
  end

  describe "#establishment" do
    let(:urn) { 123456 }
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

      it "caches the response" do
        academies_api_client = double(AcademiesApi::Client, get_establishment: AcademiesApi::Client::Result.new(double, nil))
        allow(AcademiesApi::Client).to receive(:new).and_return(academies_api_client)
        project = described_class.new(urn: urn)

        project.establishment
        project.establishment

        expect(academies_api_client).to have_received(:get_establishment).with(urn).once
      end
    end

    context "when the Academies API client returns a #{AcademiesApi::Client::NotFoundError}" do
      let(:error_message) { "Could not find establishment with URN: 123456" }
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
      let(:error_message) { "There was an error connecting to the Academies API, could not fetch establishment for URN: 123456" }
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

  describe "#incoming_trust" do
    let(:urn) { 1234567 }
    let(:ukprn) { 10061021 }
    let(:trust) { build(:academies_api_trust) }

    subject { described_class.new(incoming_trust_ukprn: ukprn) }

    context "when the API returns a successful response" do
      before { mock_successful_api_trust_response(ukprn: ukprn, trust: trust) }

      it "retreives conversion_project data from the Academies API" do
        expect(subject.incoming_trust).to eq trust
      end

      it "caches the response" do
        academies_api_client = double(AcademiesApi::Client, get_trust: AcademiesApi::Client::Result.new(double, nil))
        allow(AcademiesApi::Client).to receive(:new).and_return(academies_api_client)
        project = described_class.new(urn: urn, incoming_trust_ukprn: ukprn)

        project.incoming_trust
        project.incoming_trust

        expect(academies_api_client).to have_received(:get_trust).with(ukprn).once
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
        expect { subject.incoming_trust }.to raise_error(AcademiesApi::Client::NotFoundError, error_message)
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
        expect { subject.incoming_trust }.to raise_error(AcademiesApi::Client::Error, error_message)
      end
    end
  end
end
