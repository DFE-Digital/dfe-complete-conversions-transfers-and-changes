require "rails_helper"

RSpec.describe Project, type: :model do
  describe "Columns" do
    it { is_expected.to have_db_column(:urn).of_type :integer }
    it { is_expected.to have_db_column(:incoming_trust_ukprn).of_type :integer }
    it { is_expected.to have_db_column(:outgoing_trust_ukprn).of_type :integer }
    it { is_expected.to have_db_column(:significant_date).of_type :date }
    it { is_expected.to have_db_column(:caseworker_id).of_type :uuid }
    it { is_expected.to have_db_column(:team_leader_id).of_type :uuid }
    it { is_expected.to have_db_column(:assigned_to_id).of_type :uuid }
    it { is_expected.to have_db_column(:assigned_at).of_type :datetime }
    it { is_expected.to have_db_column(:advisory_board_date).of_type :date }
    it { is_expected.to have_db_column(:advisory_board_conditions).of_type :text }
    it { is_expected.to have_db_column(:establishment_sharepoint_link).of_type :text }
    it { is_expected.to have_db_column(:incoming_trust_sharepoint_link).of_type :text }
    it { is_expected.to have_db_column(:completed_at).of_type :datetime }
    it { is_expected.to have_db_column(:type).of_type :string }
    it { is_expected.to have_db_column(:directive_academy_order).of_type :boolean }
    it { is_expected.to have_db_column(:region).of_type :string }
    it { is_expected.to have_db_column(:academy_urn).of_type :integer }
    it { is_expected.to have_db_column(:team).of_type :string }
    it { is_expected.to have_db_column(:all_conditions_met).of_type :boolean }
  end

  describe "Relationships" do
    before { mock_successful_api_responses(urn: any_args, ukprn: any_args) }

    it { is_expected.to have_many(:notes).dependent(:destroy) }
    it { is_expected.to belong_to(:caseworker).required(false) }
    it { is_expected.to belong_to(:team_leader).required(false) }
    it { is_expected.to belong_to(:assigned_to).required(false) }
    it { is_expected.to belong_to(:tasks_data).required(true) }
    it { is_expected.to belong_to(:main_contact).optional(true) }
    it { is_expected.to belong_to(:funding_agreement_contact).optional(true) }
    it { is_expected.to belong_to(:establishment_main_contact).optional(true) }
    it { is_expected.to belong_to(:incoming_trust_main_contact).optional(true) }
    it { is_expected.to belong_to(:outgoing_trust_main_contact).optional(true) }

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

    describe "#main_contact" do
      it "returns nil when no main contact associsation exists, but there are project contacts" do
        project = create(:conversion_project)
        create_list(:project_contact, 5, project: project)

        expect(project.main_contact).to be_nil
      end

      it "returns the contact when one is set" do
        project = create(:conversion_project)
        create_list(:project_contact, 5, project: project)
        main_contact = create(:project_contact)

        project.update(main_contact: main_contact)

        expect(project.main_contact).to eql(main_contact)
      end
    end

    describe "#establishment_main_contact" do
      it "returns nil when no association exists, but there are project contacts" do
        project = create(:conversion_project)
        create_list(:project_contact, 3, project: project)

        expect(project.establishment_main_contact).to be_nil
      end

      it "returns the contact when one is set" do
        project = create(:conversion_project)
        create(:project_contact, project: project)
        establishment_main_contact = create(:project_contact)

        project.update(establishment_main_contact: establishment_main_contact)

        expect(project.establishment_main_contact).to eql(establishment_main_contact)
      end
    end

    describe "#incoming_trust_main_contact" do
      it "returns nil when no association exists, but there are project contacts" do
        project = create(:conversion_project)
        create_list(:project_contact, 3, project: project)

        expect(project.incoming_trust_main_contact).to be_nil
      end

      it "returns the contact when one is set" do
        project = create(:conversion_project)
        incoming_trust_main_contact = create(:project_contact)

        project.update(incoming_trust_main_contact: incoming_trust_main_contact)

        expect(project.incoming_trust_main_contact).to eql(incoming_trust_main_contact)
      end
    end

    describe "#outgoing_trust_main_contact" do
      it "returns nil when no association exists, but there are project contacts" do
        project = create(:conversion_project)
        create_list(:project_contact, 3, project: project)

        expect(project.outgoing_trust_main_contact).to be_nil
      end

      it "returns the contact when one is set" do
        project = create(:conversion_project)
        outgoing_trust_main_contact = create(:project_contact)

        project.update(outgoing_trust_main_contact: outgoing_trust_main_contact)

        expect(project.outgoing_trust_main_contact).to eql(outgoing_trust_main_contact)
      end
    end

    describe "#funding_agreement_contact" do
      it "returns nil when no association exists, but there are project contacts" do
        project = create(:conversion_project)
        create_list(:project_contact, 3, project: project)

        expect(project.funding_agreement_contact).to be_nil
      end

      it "returns the contact when one is set" do
        project = create(:conversion_project)
        funding_agreement_contact = create(:project_contact)

        project.update(funding_agreement_contact: funding_agreement_contact)

        expect(project.funding_agreement_contact).to eql(funding_agreement_contact)
      end
    end
  end

  describe "Validations" do
    before { mock_successful_api_responses(urn: any_args, ukprn: any_args) }

    it { is_expected.to validate_presence_of(:advisory_board_date) }
    it { is_expected.not_to validate_presence_of(:outgoing_trust_ukprn) }

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
      context "when the project does not have a new_trust_reference_number" do
        it { is_expected.to validate_presence_of(:incoming_trust_ukprn) }
      end

      context "when the project has a new_trust_reference_number" do
        it "does not validate the present of the ukprn" do
          project = build(:conversion_project, :form_a_mat)
          expect(project).to be_valid
        end
      end

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

    describe "#establishment_sharepoint_link" do
      it { is_expected.to validate_presence_of :establishment_sharepoint_link }
    end

    describe "#incoming_trust_sharepoint_link" do
      it { is_expected.to validate_presence_of :incoming_trust_sharepoint_link }
    end

    describe "#new_trust_reference_number" do
      context "when the new trust reference number is present" do
        it "validates the format of the new trust reference number" do
          project = build(:conversion_project, :form_a_mat)
          expect(project).to be_valid

          project = build(:conversion_project, new_trust_reference_number: "012345", incoming_trust_ukprn: nil)
          expect(project).to_not be_valid
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
    let(:trust) { build(:academies_api_trust) }

    context "when the project is NOT form a MAT" do
      let(:ukprn) { 10061021 }
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

    context "when the project is form a MAT" do
      subject { described_class.new(incoming_trust_ukprn: nil, new_trust_reference_number: "TR12345", new_trust_name: "The New Trust") }

      it "builds an object with the new trust UKPRN and name" do
        expect(subject.incoming_trust).to be_a(Api::AcademiesApi::Trust)
        expect(subject.incoming_trust.name).to eq "The New Trust"
        expect(subject.incoming_trust.group_identifier).to eq "TR12345"
      end
    end
  end

  describe "#member_of_parliament" do
    it "returns the details of the MP for the projects establishment constituency" do
      mock_successful_member_details

      project = build(:conversion_project)
      allow(project).to receive(:establishment).and_return(build(:academies_api_establishment))

      member_of_parliament = project.member_of_parliament

      expect(member_of_parliament.name).to eql "Member Parliament"
      expect(member_of_parliament.email).to eql "member.parliament@parliament.uk"
      expect(member_of_parliament.address.postcode).to eql "SW1A 0AA"
    end

    it "only goes to the API once per instance of Project" do
      mock_api_client = mock_successful_member_details

      project = build(:conversion_project)
      allow(project).to receive(:establishment).and_return(build(:academies_api_establishment))

      project.member_of_parliament
      project.member_of_parliament

      expect(mock_api_client).to have_received(:member_for_constituency).exactly(1).time
    end

    it "returns nil when the API returns nothing" do
      mock_nil_member_for_constituency_response

      project = build(:conversion_project)
      allow(project).to receive(:establishment).and_return(build(:academies_api_establishment))

      member_of_parliament = project.member_of_parliament

      expect(member_of_parliament).to be nil
    end

    it "sends Applications Instights an event when the API call fails" do
      ClimateControl.modify(APPLICATION_INSIGHTS_KEY: "fake-application-insights-key") do
        telemetry_client = double(ApplicationInsights::TelemetryClient, track_event: true, flush: true)
        allow(ApplicationInsights::TelemetryClient).to receive(:new).and_return(telemetry_client)

        mock_nil_member_for_constituency_response

        project = build(:conversion_project)
        allow(project).to receive(:establishment).and_return(build(:academies_api_establishment))
        project.member_of_parliament

        expect(telemetry_client).to have_received(:track_event)
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

  describe "#type_locale" do
    it "returns the project type as a string we can use in locales" do
      conversion_project = build(:conversion_project)
      expect(conversion_project.type_locale).to eq("conversion_project")

      transfer_project = build(:transfer_project)
      expect(transfer_project.type_locale).to eq("transfer_project")
    end
  end

  describe "Scopes" do
    describe "conversions" do
      before { mock_successful_api_responses(urn: any_args, ukprn: any_args) }

      it "only returns conversion projects" do
        conversion_project = create(:conversion_project)
        transfer_project = create(:transfer_project)

        projects = Project.conversions

        expect(projects).to include(conversion_project)
        expect(projects).to_not include(transfer_project)
      end
    end

    describe "transfers" do
      before { mock_successful_api_responses(urn: any_args, ukprn: any_args) }

      it "only returns transfer projects" do
        transfer_project = create(:transfer_project)
        conversion_project = create(:conversion_project)

        projects = Project.transfers

        expect(projects).to include(transfer_project)
        expect(projects).to_not include(conversion_project)
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

      it "returns projects which are in the `regional_casework_services` team" do
        assigned_project = create(:conversion_project, team: "regional_casework_services")
        unassigned_project = create(:conversion_project, team: "london")

        projects = Project.assigned_to_regional_caseworker_team
        expect(projects).to include(assigned_project)
        expect(projects).to_not include(unassigned_project)
      end
    end

    describe "not_assigned_to_regional_casework_team scope" do
      before { mock_successful_api_responses(urn: any_args, ukprn: any_args) }

      it "returns projects which have `assigned_to_regional_casework_team` set to `false`" do
        not_assigned_to_regional_caseworker = create(:conversion_project, team: "west_midlands")
        assigned_to_regional_caseworker = create(:conversion_project, team: "regional_casework_services")

        projects = Project.not_assigned_to_regional_caseworker_team
        expect(projects).to include(not_assigned_to_regional_caseworker)
        expect(projects).to_not include(assigned_to_regional_caseworker)
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

    describe "assigned_to_users" do
      before { mock_successful_api_responses(urn: any_args, ukprn: any_args) }

      it "returns projects assigned to the passed-in users" do
        first_user = create(:user, email: "first.user@education.gov.uk")
        second_user = create(:user, email: "second.user@education.gov.uk")
        third_user = create(:user, email: "third.user@education.gov.uk")

        first_users_project = create(:conversion_project, assigned_to: first_user)
        second_users_project = create(:conversion_project, assigned_to: second_user)
        third_users_project = create(:conversion_project, assigned_to: third_user)

        projects = Project.assigned_to_users([first_user, second_user])
        expect(projects).to include(first_users_project, second_users_project)
        expect(projects).to_not include(third_users_project)
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

    describe "by_trust_ukprn scope" do
      it "returns only the projects for a given trust" do
        mock_successful_api_response_to_create_any_project
        trust_ukprn = 10061021
        project_one = create(:conversion_project, incoming_trust_ukprn: trust_ukprn)
        project_two = create(:conversion_project, incoming_trust_ukprn: trust_ukprn)
        project_three = create(:conversion_project, incoming_trust_ukprn: 10134567)

        expect(Project.by_trust_ukprn(trust_ukprn)).to include(project_one, project_two)
        expect(Project.by_trust_ukprn(trust_ukprn)).to_not include(project_three)
      end
    end

    describe "filtered_by_advisory_board_date scope" do
      it "returns only projects which have an advisory board date of the chosen month & year" do
        mock_successful_api_response_to_create_any_project
        project_one = create(:conversion_project, advisory_board_date: Date.parse("2023-1-10"))
        project_two = create(:conversion_project, advisory_board_date: Date.parse("2023-1-27"))
        project_three = create(:conversion_project, advisory_board_date: Date.parse("2023-5-12"))

        expect(Project.filtered_by_advisory_board_date(1, 2023)).to include(project_one, project_two)
        expect(Project.filtered_by_advisory_board_date(1, 2023)).to_not include(project_three)
      end
    end

    describe "not_form_a_mat scope" do
      it "returns only NON form a MAT projects" do
        mock_successful_api_responses(urn: any_args, ukprn: any_args)

        form_a_mat_project = create(:conversion_project, :form_a_mat)
        single_converter_project = create(:conversion_project)

        expect(Project.not_form_a_mat).not_to include(form_a_mat_project)
        expect(Project.not_form_a_mat).to include(single_converter_project)
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

  describe "#director_of_child_services" do
    let(:urn) { 123456 }
    let(:establishment) { build(:academies_api_establishment) }
    let(:local_authority) { create(:local_authority) }

    before do
      mock_successful_api_establishment_response(urn: urn, establishment:)
      mock_successful_api_trust_response(ukprn: 10061021)
      allow_any_instance_of(Api::AcademiesApi::Establishment).to receive(:local_authority).and_return(local_authority)
    end

    subject { described_class.new(urn: urn) }

    context "when there is a director of child services" do
      let!(:director) { create(:director_of_child_services, local_authority: local_authority) }

      it "returns the director of child services via the local authority" do
        expect(subject.director_of_child_services).to eq(director)
      end
    end

    context "when there is no director of child services" do
      it "returns nil" do
        expect(subject.director_of_child_services).to be_nil
      end
    end
  end

  describe "#team" do
    subject { described_class.new(team: "regional_casework_services") }

    it "uses the enum suffix as intended" do
      expect(subject.regional_casework_services_team?).to be true
    end

    it "has the expected enum values" do
      expect(Project.teams.count).to eq(10)
    end
  end

  describe "#all_conditions_met?" do
    context "when the all conditions met task is completed" do
      let(:project) { build(:conversion_project, all_conditions_met: true) }

      it "returns true" do
        expect(project.all_conditions_met?).to eq(true)
      end
    end

    context "when the all conditions met task has not been completed" do
      let(:project) { build(:conversion_project, all_conditions_met: nil) }

      it "returns false" do
        expect(project.all_conditions_met?).to eq(false)
      end
    end
  end

  describe "#academy_order_type" do
    it "returns not applicable" do
      expect(subject.academy_order_type).to eq(:not_applicable)
    end
  end

  describe "#form_a_mat?" do
    it "returns true if the project has a TRN and new trust name" do
      project = build(:conversion_project,
        new_trust_reference_number: "TR12345",
        new_trust_name: "New Trust Company",
        incoming_trust_ukprn: nil)

      expect(project.form_a_mat?).to be true
    end

    it "returns false if the project has not TRN and new trust name, and has an incoming trust UKPRN" do
      project = build(:conversion_project,
        new_trust_reference_number: nil,
        new_trust_name: nil,
        incoming_trust_ukprn: 12345678)

      expect(project.form_a_mat?).to be false
    end
  end

  describe "delegation" do
    it "delegates local_authority to establishment" do
      local_authotity = double(code: 100)
      establishment = double
      project = build(:conversion_project)
      allow(establishment).to receive(:local_authority).and_return(local_authotity)
      allow(project).to receive(:establishment).and_return(establishment)

      expect(project.local_authority.code).to eql 100
    end

    it "delegates director_of_child_services to local_authority" do
      director_of_child_services = double(email: "director.child@domain.com")
      local_authotity = double
      establishment = double
      project = build(:conversion_project)
      allow(local_authotity).to receive(:director_of_child_services).and_return(director_of_child_services)
      allow(establishment).to receive(:local_authority).and_return(local_authotity)
      allow(project).to receive(:establishment).and_return(establishment)

      expect(project.director_of_child_services.email).to eql "director.child@domain.com"
    end
  end
end
