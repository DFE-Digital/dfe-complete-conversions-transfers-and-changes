require "rails_helper"

RSpec.describe Project, type: :model do
  describe "Columns" do
    it { is_expected.to have_db_column(:urn).of_type :integer }
    it { is_expected.to have_db_column(:incoming_trust_ukprn).of_type :integer }
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
    it { is_expected.to have_db_column(:directive_academy_order).of_type :boolean }
    it { is_expected.to have_db_column(:region).of_type :string }
    it { is_expected.to have_db_column(:academy_urn).of_type :integer }
  end

  describe "Relationships" do
    before { mock_successful_api_responses(urn: any_args, ukprn: any_args) }

    it { is_expected.to have_many(:notes).dependent(:destroy) }
    it { is_expected.to belong_to(:caseworker).required(false) }
    it { is_expected.to belong_to(:team_leader).required(false) }
    it { is_expected.to belong_to(:assigned_to).required(false) }
    it { is_expected.to belong_to(:tasks_data).required(true) }

    describe "delete related entities" do
      context "when the project is deleted" do
        it "destroys all the related notes and contacts leaving nothing orphaned" do
          project = create(:conversion_project)

          create_list(:note, 3, project: project)
          create_list(:project_contact, 3, project: project)

          project.destroy

          expect(Note.count).to be_zero
          expect(Contact::Project.count).to be_zero
          expect(Conversion::TasksData.count).to be_zero
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
          Api::AcademiesApi::Client::Result.new(nil, Api::AcademiesApi::Client::NotFoundError.new("Could not find establishment with URN: 12345"))
        end

        before do
          allow_any_instance_of(Api::AcademiesApi::Client).to \
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
          Api::AcademiesApi::Client::Result.new(nil, Api::AcademiesApi::Client::NotFoundError.new("No trust found with that UKPRN. Enter a valid UKPRN."))
        end

        before do
          allow_any_instance_of(Api::AcademiesApi::Client).to \
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

    describe "#directive_academy_order" do
      it { is_expected.to allow_value(true).for(:directive_academy_order) }
      it { is_expected.to allow_value(false).for(:directive_academy_order) }
      it { is_expected.to_not allow_value(nil).for(:directive_academy_order) }

      context "error messages" do
        it "adds an appropriate error message if the value is nil" do
          subject.assign_attributes(directive_academy_order: nil)
          subject.valid?
          expect(subject.errors[:directive_academy_order]).to include("Select yes if this project has had a directive academy order issued")
        end
      end
    end

    describe "academy urn" do
      context "when there is no academy urn" do
        it "is valid" do
          project = build(:conversion_project, academy_urn: nil)

          expect(project).to be_valid
        end
      end

      context "when there is an academy urn" do
        it "the urn must be valid" do
          project = build(:conversion_project, academy_urn: 12345678)

          expect(project).to be_invalid

          project = build(:conversion_project, academy_urn: 123456)

          expect(project).to be_valid
        end
      end
    end
  end

  describe "#academy" do
    it "returns an establishment object when the urn can be found" do
      mock_successful_api_response_to_create_any_project

      project = build(:conversion_project, academy_urn: 123456)

      expect(project.academy).to be_a(Api::AcademiesApi::Establishment)
    end

    it "returns nil when the urn cannot be found" do
      mock_successful_api_response_to_create_any_project
      mock_establishment_not_found(urn: 999999)

      project = build(:conversion_project, academy_urn: 999999)

      expect(project.academy).to be_nil
    end
  end

  describe "#academy_found?" do
    before { mock_successful_api_response_to_create_any_project }

    it "returns true when the academy can be found" do
      project = build(:conversion_project, academy_urn: 123456)

      expect(project.academy_found?).to eql true
    end

    it "returns false when the academy cannot be found" do
      project = build(:conversion_project, academy_urn: 123456)

      allow_any_instance_of(Project).to receive(:academy).and_return(nil)

      expect(project.academy_found?).to eql false
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
        academies_api_client = double(Api::AcademiesApi::Client, get_establishment: Api::AcademiesApi::Client::Result.new(double, nil))
        allow(Api::AcademiesApi::Client).to receive(:new).and_return(academies_api_client)
        project = described_class.new(urn: urn)

        project.establishment
        project.establishment

        expect(academies_api_client).to have_received(:get_establishment).with(urn).once
      end
    end

    context "when the Academies API client returns a #{Api::AcademiesApi::Client::NotFoundError}" do
      let(:error_message) { "Could not find establishment with URN: 123456" }
      let(:error) { Api::AcademiesApi::Client::Result.new(nil, Api::AcademiesApi::Client::NotFoundError.new(error_message)) }

      before do
        allow_any_instance_of(Api::AcademiesApi::Client).to \
          receive(:get_establishment).with(urn) { error }
      end

      it "raises the error" do
        expect { subject.establishment }.to raise_error(Api::AcademiesApi::Client::NotFoundError, error_message)
      end
    end

    context "when the Academies API client returns a #{Api::AcademiesApi::Client::Error}" do
      let(:error_message) { "There was an error connecting to the Academies API, could not fetch establishment for URN: 123456" }
      let(:error) { Api::AcademiesApi::Client::Result.new(nil, Api::AcademiesApi::Client::Error.new(error_message)) }

      before do
        allow_any_instance_of(Api::AcademiesApi::Client).to \
          receive(:get_establishment).with(urn) { error }
      end

      it "raises the error" do
        expect { subject.establishment }.to raise_error(Api::AcademiesApi::Client::Error, error_message)
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
        academies_api_client = double(Api::AcademiesApi::Client, get_trust: Api::AcademiesApi::Client::Result.new(double, nil))
        allow(Api::AcademiesApi::Client).to receive(:new).and_return(academies_api_client)
        project = described_class.new(urn: urn, incoming_trust_ukprn: ukprn)

        project.incoming_trust
        project.incoming_trust

        expect(academies_api_client).to have_received(:get_trust).with(ukprn).once
      end
    end

    context "when the Academies API client returns a #{Api::AcademiesApi::Client::NotFoundError}" do
      let(:error_message) { "Could not find trust for UKPRN 10061021" }
      let(:error) { Api::AcademiesApi::Client::Result.new(nil, Api::AcademiesApi::Client::NotFoundError.new(error_message)) }

      before do
        allow_any_instance_of(Api::AcademiesApi::Client).to \
          receive(:get_trust).with(ukprn) { error }
      end

      it "raises the error" do
        expect { subject.incoming_trust }.to raise_error(Api::AcademiesApi::Client::NotFoundError, error_message)
      end
    end

    context "when the Academies API client returns a #{Api::AcademiesApi::Client::Error}" do
      let(:error_message) { "There was an error connecting to the Academies API, could not fetch trust with UKPRN 10061021" }
      let(:error) { Api::AcademiesApi::Client::Result.new(nil, Api::AcademiesApi::Client::Error.new(error_message)) }

      before do
        allow_any_instance_of(Api::AcademiesApi::Client).to \
          receive(:get_trust).with(ukprn) { error }
      end

      it "raises the error" do
        expect { subject.incoming_trust }.to raise_error(Api::AcademiesApi::Client::Error, error_message)
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
      let(:tasks_data) { create(:conversion_tasks_data, conditions_met_confirm_all_conditions_met: true) }
      let(:project) { build(:conversion_project, tasks_data: tasks_data) }

      it "returns true" do
        expect(project.all_conditions_met?).to eq(true)
      end
    end

    context "when the all conditions met task has not been completed" do
      let(:tasks_data) { create(:conversion_tasks_data, conditions_met_confirm_all_conditions_met: nil) }
      let(:project) { build(:conversion_project, tasks_data: tasks_data) }

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

    describe "completed scope" do
      before { mock_successful_api_responses(urn: any_args, ukprn: any_args) }

      it "only returns completed projects ordered by completed at date" do
        completed_project_1 = create(:conversion_project, completed_at: Date.today - 1.year)
        completed_project_2 = create(:conversion_project, completed_at: Date.today - 6.months)
        in_progress_project = create(:conversion_project, completed_at: nil)

        projects = Project.completed

        expect(projects.first).to eql completed_project_2
        expect(projects.last).to eql completed_project_1

        expect(projects).to_not include(in_progress_project)
      end
    end

    describe "not_completed scope" do
      before { mock_successful_api_responses(urn: any_args, ukprn: any_args) }

      it "only returns projects where completed_at is nil" do
        completed_project = create(:conversion_project, completed_at: Date.today - 1.year)
        in_progress_project_1 = create(:conversion_project, completed_at: nil)
        in_progress_project_2 = create(:conversion_project, completed_at: nil)

        projects = Project.not_completed

        expect(projects).to include(in_progress_project_1, in_progress_project_2)
        expect(projects).to_not include(completed_project)
      end
    end

    describe "#assigned" do
      it "only includes projects assigned to a user" do
        mock_successful_api_response_to_create_any_project
        assigned_project = create(:conversion_project)
        unassigned_project = create(:conversion_project, :unassigned)

        projects = Project.assigned

        expect(projects).to include(assigned_project)
        expect(projects).to_not include(unassigned_project)
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

      it "does not include unassigned projects" do
        mock_successful_api_response_to_create_any_project
        in_progress_project = create(:conversion_project)
        unassigned_project = create(:conversion_project, :unassigned)

        projects = Project.in_progress

        expect(projects).to include in_progress_project
        expect(projects).to_not include unassigned_project
      end

      it "is ordered by conversion date ascending" do
        mock_successful_api_response_to_create_any_project
        create(:conversion_project, conversion_date: Date.today.at_beginning_of_month + 2.month)
        project_converting_last = create(:conversion_project, conversion_date: Date.today.at_beginning_of_month + 3.month)
        project_converting_first = create(:conversion_project, conversion_date: Date.today.at_beginning_of_month + 1.month)

        projects = Project.in_progress

        expect(projects.first).to eql project_converting_first
        expect(projects.last).to eql project_converting_last
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

    describe "not_assigned_to_regional_casework_team scope" do
      before { mock_successful_api_responses(urn: any_args, ukprn: any_args) }

      it "returns projects which have `assigned_to_regional_casework_team` set to `false`" do
        not_assigned_to_regional_caseworker = create(:conversion_project, assigned_to_regional_caseworker_team: false)
        assigned_to_regional_caseworker = create(:conversion_project, assigned_to_regional_caseworker_team: true)

        projects = Project.not_assigned_to_regional_caseworker_team
        expect(projects).to include(not_assigned_to_regional_caseworker)
        expect(projects).to_not include(assigned_to_regional_caseworker)
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

    describe "assigned_to" do
      before { mock_successful_api_responses(urn: any_args, ukprn: any_args) }

      it "returns project for the passed user" do
        first_user = create(:user, email: "first.user@education.gov.uk")
        second_user = create(:user, email: "second.user@education.gov.uk")

        first_users_project = create(:conversion_project, assigned_to: first_user)
        second_users_project = create(:conversion_project, assigned_to: second_user)

        first_users_projects = Project.assigned_to(first_user)
        expect(first_users_projects).to include(first_users_project)
        expect(first_users_projects).not_to include(second_users_project)

        second_users_projects = Project.assigned_to(second_user)
        expect(second_users_projects).to include(second_users_project)
        expect(second_users_projects).not_to include(first_users_project)
      end
    end

    describe "#voluntary" do
      it "returns only projects where directive_academy_order is false" do
        mock_successful_api_response_to_create_any_project
        voluntary_project = create(:conversion_project, directive_academy_order: false)
        sponsored_project = create(:conversion_project, directive_academy_order: true)
        projects = Project.voluntary

        expect(projects).to include(voluntary_project)
        expect(projects).not_to include(sponsored_project)
      end
    end

    describe "#sponsored" do
      it "returns only projects where directive_academy_order is true" do
        mock_successful_api_response_to_create_any_project
        voluntary_project = create(:conversion_project, directive_academy_order: false)
        sponsored_project = create(:conversion_project, directive_academy_order: true)
        projects = Project.sponsored

        expect(projects).to include(sponsored_project)
        expect(projects).not_to include(voluntary_project)
      end
    end

    describe "#no_academy_urn" do
      it "returns only projects where academy_urn is nil" do
        mock_successful_api_response_to_create_any_project
        new_project = create(:conversion_project, academy_urn: nil)
        existing_project = create(:conversion_project, academy_urn: 126041)
        projects = Project.no_academy_urn

        expect(projects).to include(new_project)
        expect(projects).not_to include(existing_project)
      end
    end

    describe "#with_academy_urn" do
      it "returns only projects where academy_urn is NOT nil" do
        mock_successful_api_response_to_create_any_project
        new_project = create(:conversion_project, academy_urn: nil)
        existing_project = create(:conversion_project, academy_urn: 126041)
        projects = Project.with_academy_urn

        expect(projects).to include(existing_project)
        expect(projects).not_to include(new_project)
      end
    end

    describe "by_region scope" do
      it "returns only projects for the given region" do
        mock_successful_api_response_to_create_any_project
        london_project = create(:conversion_project, region: Project.regions["london"])
        west_mids_project = create(:conversion_project, region: Project.regions["west_midlands"])

        expect(Project.by_region("london")).to include(london_project)
        expect(Project.by_region("london")).to_not include(west_mids_project)
      end
    end

    describe "added_by scope" do
      it "returns only the projects that were added by the given user" do
        mock_successful_api_response_to_create_any_project
        user = create(:user)
        added_project = create(:conversion_project, regional_delivery_officer: user)
        other_project = create(:conversion_project)

        expect(Project.added_by(user)).to include(added_project)
        expect(Project.added_by(user)).to_not include(other_project)
      end
    end
  end

  describe "region" do
    before { mock_successful_api_responses(urn: any_args, ukprn: any_args) }

    it "uses the enum value for regions" do
      project = create(:conversion_project, region: "E")
      expect(project.region).to eq("east_midlands")
    end
  end

  describe "#revised_conversion_date" do
    let(:first_of_this_month) { Date.today.at_beginning_of_month }
    let(:first_of_future_month) { Date.today.at_beginning_of_month + 3.months }

    it "does not include projects whose conversion date stayed the same" do
      user = create(:user)
      mock_successful_api_response_to_create_any_project
      project = create(:conversion_project, assigned_to: user, conversion_date_provisional: false)
      create(:date_history, project: project, previous_date: first_of_this_month, revised_date: first_of_this_month)

      another_project = create(:conversion_project, assigned_to: user, conversion_date_provisional: false)
      create(:date_history, project: another_project, previous_date: first_of_this_month, revised_date: first_of_future_month)

      projects = Project.conversion_date_revised_from(first_of_this_month.month, first_of_this_month.year)

      expect(projects).to include another_project
      expect(projects).not_to include project
    end

    it "only includes projects whose latest date history previous date is in the supplied month and year" do
      user = create(:user)
      mock_successful_api_response_to_create_any_project

      another_project = create(:conversion_project, assigned_to: user, conversion_date_provisional: false)
      create(:date_history, project: another_project, previous_date: first_of_this_month, revised_date: first_of_future_month)

      yet_another_project = create(:conversion_project, assigned_to: user, conversion_date_provisional: false)
      create(:date_history, project: yet_another_project, previous_date: first_of_future_month, revised_date: first_of_future_month + 3.months)

      projects = Project.conversion_date_revised_from(first_of_future_month.month, first_of_future_month.year)

      expect(projects).to include yet_another_project
      expect(projects).not_to include another_project
    end
  end
end
