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
    it { is_expected.to have_db_column(:establishment_sharepoint_link).of_type :text }
    it { is_expected.to have_db_column(:trust_sharepoint_link).of_type :text }
    it { is_expected.to have_db_column(:closed_at).of_type :datetime }
  end

  describe "Relationships" do
    before { mock_successful_api_responses(urn: any_args, ukprn: any_args) }

    it { is_expected.to have_many(:sections).dependent(:destroy) }
    it { is_expected.to have_many(:notes).dependent(:destroy) }
    it { is_expected.to belong_to(:caseworker).required(false) }
    it { is_expected.to belong_to(:team_leader).required(false) }

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

  describe "by_target_completion_date scope" do
    before { mock_successful_api_responses(urn: any_args, ukprn: any_args) }

    it "shows the project that complete earliest first" do
      last_project = create(:project, target_completion_date: Date.today.beginning_of_month + 3.years)
      middle_project = create(:project, target_completion_date: Date.today.beginning_of_month + 2.years)
      first_project = create(:project, target_completion_date: Date.today.beginning_of_month + 1.year)

      ordered_projects = Project.by_target_completion_date

      expect(ordered_projects[0]).to eq first_project
      expect(ordered_projects[1]).to eq middle_project
      expect(ordered_projects[2]).to eq last_project
    end
  end

  describe "#closed?" do
    context "when the closed_at is nil, i.e. the project is active" do
      it "returns false" do
        project = build(:project, closed_at: nil)
        expect(project.closed?).to eq false
      end
    end

    context "when the closed_at is set, i.e. the project is closed" do
      it "returns true" do
        project = build(:project, closed_at: DateTime.now)
        expect(project.closed?).to eq true
      end
    end
  end
end
