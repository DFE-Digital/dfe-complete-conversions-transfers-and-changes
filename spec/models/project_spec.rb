require "rails_helper"

RSpec.describe Project, type: :model do
  describe "Columns" do
    it { is_expected.to have_db_column(:urn).of_type :integer }
    it { is_expected.to have_db_column(:incoming_trust_ukprn).of_type :integer }
    it { is_expected.to have_db_column(:provisional_conversion_date).of_type :date }
    it { is_expected.to have_db_column(:conversion_date).of_type :date }
    it { is_expected.to have_db_column(:caseworker_id).of_type :uuid }
    it { is_expected.to have_db_column(:team_leader_id).of_type :uuid }
    it { is_expected.to have_db_column(:assigned_to_id).of_type :uuid }
    it { is_expected.to have_db_column(:assigned_at).of_type :datetime }
    it { is_expected.to have_db_column(:advisory_board_date).of_type :date }
    it { is_expected.to have_db_column(:advisory_board_conditions).of_type :text }
    it { is_expected.to have_db_column(:establishment_sharepoint_link).of_type :text }
    it { is_expected.to have_db_column(:trust_sharepoint_link).of_type :text }
    it { is_expected.to have_db_column(:completed_at).of_type :datetime }
    it { is_expected.to have_db_column(:type).of_type :string }
    it { is_expected.to have_db_column(:assigned_to_regional_caseworker_team).of_type :boolean }
  end

  describe "Relationships" do
    before { mock_successful_api_responses(urn: any_args, ukprn: any_args) }

    it { is_expected.to have_many(:notes).dependent(:destroy) }
    it { is_expected.to belong_to(:caseworker).required(false) }
    it { is_expected.to belong_to(:team_leader).required(false) }
    it { is_expected.to belong_to(:assigned_to).required(false) }
    it { is_expected.to belong_to(:task_list).required(true) }

    describe "delete related entities" do
      context "when the project is deleted" do
        it "destroys all the related notes and contacts leaving nothing orphaned" do
          project = create(:conversion_project)

          create_list(:note, 3, project: project)
          create_list(:contact, 3, project: project)

          project.destroy

          expect(Note.count).to be_zero
          expect(Contact.count).to be_zero
          expect(Conversion::Voluntary::TaskList.count).to be_zero
        end
      end
    end
  end

  describe "Validations" do
    before { mock_successful_api_responses(urn: any_args, ukprn: any_args) }

    it { is_expected.to validate_presence_of(:advisory_board_date) }

    describe "#urn" do
      it { is_expected.to validate_presence_of(:urn) }
      it { is_expected.to allow_value(123456).for(:urn) }
      it { is_expected.not_to allow_values(12345, 1234567).for(:urn) }

      context "when no establishment with that URN exists in the API and the URN is present" do
        let(:no_establishment_found_result) do
          AcademiesApi::Client::Result.new(nil, AcademiesApi::Client::NotFoundError.new("Could not find establishment with URN: 12345"))
        end

        before do
          allow_any_instance_of(AcademiesApi::Client).to \
            receive(:get_establishment) { no_establishment_found_result }

          subject.assign_attributes(urn: 123456)
        end

        it "is invalid" do
          expect(subject).to_not be_valid
          expect(subject.errors[:urn]).to include(I18n.t("errors.attributes.urn.no_establishment_found"))
        end
      end
    end

    describe "#incoming_trust_ukprn" do
      context "when no trust with that UKPRN exists in the API and the UKPRN is present" do
        let(:no_trust_found_result) do
          AcademiesApi::Client::Result.new(nil, AcademiesApi::Client::NotFoundError.new("No trust found with that UKPRN. Enter a valid UKPRN."))
        end

        before do
          allow_any_instance_of(AcademiesApi::Client).to \
            receive(:get_trust) { no_trust_found_result }

          subject.assign_attributes(incoming_trust_ukprn: 12345678)
        end

        it "is invalid" do
          expect(subject).to_not be_valid
          expect(subject.errors[:incoming_trust_ukprn]).to include(I18n.t("errors.attributes.incoming_trust_ukprn.no_trust_found"))
        end
      end
    end

    describe "#conversion_date" do
      it { is_expected.to validate_presence_of(:conversion_date) }

      context "when the date is not on the first of the month" do
        subject { build(:conversion_project, conversion_date: Date.today.months_since(6).at_end_of_month) }

        it "is invalid" do
          expect(subject).to_not be_valid
          expect(subject.errors[:conversion_date]).to include(I18n.t("errors.attributes.conversion_date.must_be_first_of_the_month"))
        end
      end
    end

    describe "#establishment_sharepoint_link" do
      it { is_expected.to validate_presence_of :establishment_sharepoint_link }
    end

    describe "#trust_sharepoint_link" do
      it { is_expected.to validate_presence_of :trust_sharepoint_link }
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

  describe "#completed?" do
    context "when the completed_at is nil, i.e. the project is active" do
      it "returns false" do
        project = build(:conversion_project, completed_at: nil)
        expect(project.completed?).to eq false
      end
    end

    context "when the completed_at is set, i.e. the project is completed" do
      it "returns true" do
        project = build(:conversion_project, completed_at: DateTime.now)
        expect(project.completed?).to eq true
      end
    end
  end

  describe "unassigned_to_user?" do
    context "when the project has an `assigned_to` value" do
      it "returns false" do
        project = build(:conversion_project, assigned_to: create(:user))
        expect(project.unassigned_to_user?).to eq false
      end
    end

    context "when the project has no `assigned_to` value" do
      it "returns true" do
        project = build(:conversion_project, assigned_to: nil)
        expect(project.unassigned_to_user?).to eq true
      end
    end
  end

  describe "#all_conditions_met?" do
    context "when the all conditions met task is completed" do
      let(:task_list) { create(:voluntary_conversion_task_list, conditions_met_confirm_all_conditions_met: true) }
      let(:project) { build(:conversion_project, task_list: task_list) }

      it "returns true" do
        expect(project.all_conditions_met?).to eq(true)
      end
    end

    context "when the all conditions met task has not been completed" do
      let(:task_list) { create(:voluntary_conversion_task_list, conditions_met_confirm_all_conditions_met: nil) }
      let(:project) { build(:conversion_project, task_list: task_list) }

      it "returns false" do
        expect(project.all_conditions_met?).to eq(false)
      end
    end
  end

  describe "Scopes" do
    describe "conversions" do
      before { mock_successful_api_responses(urn: any_args, ukprn: any_args) }

      it "only returns conversions projects" do
        conversion_project = create(:conversion_project)
        transfer_project = create(:conversion_project, type: "Transfer::Project")

        projects = Project.conversions

        expect(projects).to include(conversion_project)
        expect(projects).to_not include(transfer_project)
      end
    end

    describe "conversions_voluntary" do
      before { mock_successful_api_responses(urn: any_args, ukprn: any_args) }

      it "only returns voluntary conversion projects" do
        voluntary_conversion_project = create(:voluntary_conversion_project)
        involuntary_conversion_project = create(:involuntary_conversion_project)

        projects = Project.conversions_voluntary

        expect(projects).to include(voluntary_conversion_project)
        expect(projects).to_not include(involuntary_conversion_project)
      end
    end

    describe "conversions_involuntary" do
      before { mock_successful_api_responses(urn: any_args, ukprn: any_args) }

      it "only returns voluntary conversion projects" do
        voluntary_conversion_project = create(:voluntary_conversion_project)
        involuntary_conversion_project = create(:involuntary_conversion_project)

        projects = Project.conversions_involuntary

        expect(projects).to include(involuntary_conversion_project)
        expect(projects).to_not include(voluntary_conversion_project)
      end
    end

    describe "completed scope" do
      before { mock_successful_api_responses(urn: any_args, ukprn: any_args) }

      it "only returns completed projects" do
        completed_project_1 = create(:conversion_project, completed_at: Date.today - 1.year)
        completed_project_2 = create(:conversion_project, completed_at: Date.today - 1.year)
        open_project = create(:conversion_project, completed_at: nil)

        projects = Project.completed

        expect(projects).to include(completed_project_1, completed_project_2)
        expect(projects).to_not include(open_project)
      end
    end

    describe "in_progress scope" do
      before { mock_successful_api_responses(urn: any_args, ukprn: any_args) }

      it "only returns open projects" do
        completed_project = create(:conversion_project, completed_at: Date.today - 1.year)
        open_project_1 = create(:conversion_project, completed_at: nil)
        open_project_2 = create(:conversion_project, completed_at: nil)

        projects = Project.in_progress

        expect(projects).to include(open_project_1, open_project_2)
        expect(projects).to_not include(completed_project)
      end
    end

    describe "assigned_to_caseworker scope" do
      before { mock_successful_api_responses(urn: any_args, ukprn: any_args) }

      it "returns projects which have the user as either the `caseworker` or `assigned_to`" do
        user = create(:user, :caseworker)
        other_project = create(:conversion_project)
        caseworker_project = create(:conversion_project, caseworker: user)
        assigned_to_project = create(:conversion_project, assigned_to: user)

        projects = Project.assigned_to_caseworker(user)
        expect(projects).to include(caseworker_project, assigned_to_project)
        expect(projects).to_not include(other_project)
      end
    end

    describe "assigned_to_regional_delivery_officer scope" do
      before { mock_successful_api_responses(urn: any_args, ukprn: any_args) }

      it "returns projects which have the user as either the `regional_delivery_officer` or `assigned_to`" do
        user = create(:user, :regional_delivery_officer)
        other_project = create(:conversion_project)
        rdo_project = create(:conversion_project, regional_delivery_officer: user)
        assigned_to_project = create(:conversion_project, assigned_to: user)

        projects = Project.assigned_to_regional_delivery_officer(user)
        expect(projects).to include(rdo_project, assigned_to_project)
        expect(projects).to_not include(other_project)
      end
    end

    describe "unassigned_to_user scope" do
      before { mock_successful_api_responses(urn: any_args, ukprn: any_args) }

      it "returns projects which do not have an `assigned_to` value" do
        user = create(:user, :regional_delivery_officer)
        assigned_project = create(:conversion_project, assigned_to: user)
        unassigned_project = create(:conversion_project, assigned_to: nil)

        projects = Project.unassigned_to_user
        expect(projects).to include(unassigned_project)
        expect(projects).to_not include(assigned_project)
      end
    end

    describe "assigned_to_regional_casework_team scope" do
      before { mock_successful_api_responses(urn: any_args, ukprn: any_args) }

      it "returns projects which have `assigned_to_regional_casework_team` set to `true`" do
        assigned_project = create(:conversion_project, assigned_to_regional_caseworker_team: true)
        unassigned_project = create(:conversion_project, assigned_to_regional_caseworker_team: false)

        projects = Project.assigned_to_regional_caseworker_team
        expect(projects).to include(assigned_project)
        expect(projects).to_not include(unassigned_project)
      end
    end

    describe "opening_by_month_year scope" do
      before { mock_successful_api_responses(urn: any_args, ukprn: any_args) }

      it "only returns projects with a confirmed conversion date" do
        conversion_project = create(:conversion_project)
        expect(Project.opening_by_month_year(1, 2023)).to_not include(conversion_project)
      end

      it "only returns projects with a confirmed conversion date in that month & year" do
        project_in_scope = create(:conversion_project, conversion_date: Date.new(2023, 1, 1), conversion_date_provisional: false)
        project_not_in_scope = create(:conversion_project, conversion_date: Date.new(2023, 2, 1), conversion_date_provisional: true)
        project_without_conversion_date = create(:conversion_project)

        expect(Project.opening_by_month_year(1, 2023)).to_not include(project_not_in_scope, project_without_conversion_date)
        expect(Project.opening_by_month_year(1, 2023)).to include(project_in_scope)
      end
    end

    describe "provisional scope" do
      it "only returns projects with a provisional conversion date" do
        mock_successful_api_responses(urn: any_args, ukprn: any_args)
        provisional_project = create(:conversion_project, conversion_date_provisional: true)
        confirmed_project = create(:conversion_project, conversion_date_provisional: false)

        scoped_projects = Project.provisional

        expect(scoped_projects).to include provisional_project
        expect(scoped_projects).not_to include confirmed_project
      end
    end

    describe "confirmed scope" do
      it "only returns projects with a confirmed conversion date" do
        mock_successful_api_responses(urn: any_args, ukprn: any_args)
        provisional_project = create(:conversion_project, conversion_date_provisional: true)
        confirmed_project = create(:conversion_project, conversion_date_provisional: false)

        scoped_projects = Project.confirmed

        expect(scoped_projects).to include confirmed_project
        expect(scoped_projects).not_to include provisional_project
      end
    end

    describe "by_conversion_date scope" do
      before { mock_successful_api_responses(urn: any_args, ukprn: any_args) }

      it "shows the project that will convert earliest first" do
        last_project = create(:conversion_project, conversion_date: Date.today.beginning_of_month + 3.years)
        middle_project = create(:conversion_project, conversion_date: Date.today.beginning_of_month + 2.years)
        first_project = create(:conversion_project, conversion_date: Date.today.beginning_of_month + 1.year)

        scoped_projects = Project.by_conversion_date

        expect(scoped_projects[0].id).to eq first_project.id
        expect(scoped_projects[1].id).to eq middle_project.id
        expect(scoped_projects[2].id).to eq last_project.id
      end
    end
  end
end
