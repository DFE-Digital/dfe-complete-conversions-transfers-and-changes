require "rails_helper"

RSpec.describe Conversion::CreateProjectForm, type: :model do
  let(:form_factory) { "create_project_form" }
  let(:task_list_class) { Conversion::Voluntary::TaskList }

  context "when the project is successfully created" do
    let(:establishment) { build(:academies_api_establishment) }
    before do
      mock_successful_api_establishment_response(urn: 123456, establishment:)
      mock_successful_api_trust_response(ukprn: 10061021)

      ActiveJob::Base.queue_adapter = :test
      ActiveJob::Base.queue_adapter.enqueued_jobs.clear
    end

    context "when the project is being assigned to the Regional Caseworker Team" do
      it "sends a notification to team leaders" do
        team_leader = create(:user, :team_leader)
        another_team_leader = create(:user, :team_leader)

        project = build(:create_project_form, assigned_to_regional_caseworker_team: true).save

        expect(ActionMailer::MailDeliveryJob)
          .to(have_been_enqueued.on_queue("default")
                                .with("TeamLeaderMailer", "new_project_created", "deliver_now", args: [team_leader, project]))
        expect(ActionMailer::MailDeliveryJob)
          .to(have_been_enqueued.on_queue("default")
                                .with("TeamLeaderMailer", "new_project_created", "deliver_now", args: [another_team_leader, project]))
      end

      it "does not set Project.assigned_to" do
        project = build(:create_project_form, assigned_to_regional_caseworker_team: true).save

        expect(project.assigned_to).to be_nil
      end

      it "sets the team attribute on the project to regional_casework_services" do
        project = build(:create_project_form, assigned_to_regional_caseworker_team: true).save
        expect(project.team).to eq("regional_casework_services")
      end
    end

    context "when the project is NOT being assigned to the Regional Caseworker Team" do
      it "does not send a notification to team leaders" do
        _team_leader = create(:user, :team_leader)
        _another_team_leader = create(:user, :team_leader)

        _project = build(:create_project_form, assigned_to_regional_caseworker_team: false).save

        expect(ActionMailer::MailDeliveryJob).to_not(have_been_enqueued)
      end

      it "sets Project.assigned_to the current user" do
        project = build(:create_project_form, assigned_to_regional_caseworker_team: false).save

        expect(project.assigned_to).to_not be_nil
      end

      it "sets Project.assigned_at to now" do
        freeze_time
        project = build(:create_project_form, assigned_to_regional_caseworker_team: false).save
        expect(project.assigned_at).to eq DateTime.now
      end

      it "sets the team attribute on the project to the region of the establishment" do
        project = build(:create_project_form, assigned_to_regional_caseworker_team: false).save
        expect(project.team).to eq("west_midlands")
      end
    end

    context "and the establishment has a diocese" do
      it "sets the church supplemental agreement task to not applicable" do
        establishment = build(:academies_api_establishment, diocese_code: "0000")
        result = Api::AcademiesApi::Client::Result.new(establishment, nil)
        allow_any_instance_of(Api::AcademiesApi::Client).to receive(:get_establishment).with(123456).and_return(result)
        project = build(:create_project_form).save

        expect(project.tasks_data.church_supplemental_agreement_not_applicable).to be true
      end
    end

    context "and an academy order was issued, i.e. the project is voluntary" do
      it "sets the Process the sponsored support grant task as not applicable" do
        project = build(:create_project_form, directive_academy_order: false).save

        expect(project.tasks_data.sponsored_support_grant_not_applicable).to be true
      end
    end
  end

  describe "validations" do
    before { mock_successful_api_responses(urn: any_args, ukprn: any_args) }

    it { is_expected.to validate_presence_of(:establishment_sharepoint_link) }
    it { is_expected.to validate_presence_of(:trust_sharepoint_link) }

    describe "provisional_conversion_date" do
      it { is_expected.to validate_presence_of(:provisional_conversion_date) }

      it "must be in the future" do
        form = build(
          form_factory.to_sym,
          provisional_conversion_date: {3 => 1, 2 => 1, 1 => 2030}
        )
        expect(form).to be_valid

        form.provisional_conversion_date = {3 => 1, 2 => 1, 1 => 2020}
        expect(form).to be_invalid
      end

      it "cannot be in the past" do
        form = build(
          form_factory.to_sym,
          provisional_conversion_date: {3 => 1, 2 => 1, 1 => 2030}
        )
        expect(form).to be_valid

        form.provisional_conversion_date = {3 => 1, 2 => 1, 1 => 2020}
        expect(form).to be_invalid
      end

      context "when the date params are partially complete" do
        it "treats the date as invalid" do
          form = build(form_factory.to_sym, provisional_conversion_date: {3 => 1, 2 => 10, 1 => nil})
          expect(form).to be_invalid
          expect(form.errors.of_kind?(:provisional_conversion_date, :invalid)).to be true

          form = build(form_factory.to_sym, provisional_conversion_date: {3 => 1, 2 => nil, 1 => 2022})
          expect(form).to be_invalid
          expect(form.errors.of_kind?(:provisional_conversion_date, :invalid)).to be true
        end
      end

      context "when the month and year are missing" do
        it "treats the date as blank" do
          form = build(form_factory.to_sym, provisional_conversion_date: {3 => 1, 2 => nil, 1 => nil})
          expect(form).to be_invalid
          expect(form.errors.of_kind?(:provisional_conversion_date, :blank)).to be true
        end
      end

      context "when all the date parameters are missing" do
        it "treats the date as blank" do
          form = build(form_factory.to_sym, provisional_conversion_date: {3 => nil, 2 => nil, 1 => nil})
          expect(form).to be_invalid
          expect(form.errors.of_kind?(:provisional_conversion_date, :blank)).to be true
        end
      end

      context "when the date doesn't exist" do
        it "treats the date as invalid" do
          form = build(form_factory.to_sym, provisional_conversion_date: {3 => 31, 2 => 2, 1 => 2030})
          expect(form).to be_invalid
          expect(form.errors.of_kind?(:provisional_conversion_date, :invalid)).to be true
        end
      end

      context "when the isn't a date" do
        it "treats the date as invalid" do
          form = build(form_factory.to_sym, provisional_conversion_date: {3 => -1, 2 => -1, 1 => 0})
          expect(form).to be_invalid
          expect(form.errors.of_kind?(:provisional_conversion_date, :invalid)).to be true

          form = build(form_factory.to_sym, provisional_conversion_date: {3 => "not", 2 => "a", 1 => "date"})
          expect(form).to be_invalid
          expect(form.errors.of_kind?(:provisional_conversion_date, :invalid)).to be true
        end
      end
    end

    describe "advisory_board_date" do
      it { is_expected.to validate_presence_of(:advisory_board_date) }

      it "must be in the past" do
        form = build(
          form_factory.to_sym,
          advisory_board_date: {3 => 1, 2 => 1, 1 => 2020}
        )
        expect(form).to be_valid

        form.advisory_board_date = {3 => 1, 2 => 1, 1 => 2030}
        expect(form).to be_invalid
      end

      it "cannot be in the future" do
        form = build(
          form_factory.to_sym,
          advisory_board_date: {3 => 1, 2 => 1, 1 => 2020}
        )
        expect(form).to be_valid

        form.advisory_board_date = {3 => 1, 2 => 1, 1 => 2030}
        expect(form).to be_invalid
      end

      context "when the date parameters are partially complete" do
        it "treats the date as invalid" do
          form = build(form_factory.to_sym, advisory_board_date: {3 => nil, 2 => 10, 1 => 1})
          expect(form).to be_invalid
          expect(form.errors.of_kind?(:advisory_board_date, :invalid)).to be true

          form = build(form_factory.to_sym, advisory_board_date: {3 => 2022, 2 => nil, 1 => 1})
          expect(form).to be_invalid
          expect(form.errors.of_kind?(:advisory_board_date, :invalid)).to be true

          form = build(form_factory.to_sym, advisory_board_date: {3 => 2022, 2 => 10, 1 => nil})
          expect(form).to be_invalid
          expect(form.errors.of_kind?(:advisory_board_date, :invalid)).to be true
        end
      end

      context "when all the date parameters are missing" do
        it "treats the date as blank" do
          form = build(form_factory.to_sym, advisory_board_date: {3 => nil, 2 => nil, 1 => nil})
          expect(form).to be_invalid
          expect(form.errors.of_kind?(:advisory_board_date, :blank)).to be true
        end
      end

      context "when no date value is set" do
        it "treats the date as blank" do
          form = build(form_factory.to_sym, advisory_board_date: nil)
          expect(form).to be_invalid
          expect(form.errors.of_kind?(:advisory_board_date, :blank)).to be true
        end
      end

      context "when the date doesn't exist" do
        it "treats the date as invalid" do
          form = build(form_factory.to_sym, advisory_board_date: {3 => 31, 2 => 2, 1 => 2030})
          expect(form).to be_invalid
          expect(form.errors.of_kind?(:advisory_board_date, :invalid)).to be true
        end
      end

      context "when the isn't a date" do
        it "treats the date as invalid" do
          form = build(form_factory.to_sym, advisory_board_date: {3 => -1, 2 => -1, 1 => 0})
          expect(form).to be_invalid
          expect(form.errors.of_kind?(:advisory_board_date, :invalid)).to be true

          form = build(form_factory.to_sym, advisory_board_date: {3 => "not", 2 => "a", 1 => "date"})
          expect(form).to be_invalid
          expect(form.errors.of_kind?(:advisory_board_date, :invalid)).to be true
        end
      end
    end

    describe "directive_academy_order" do
      it "validates the presence of directive_academy_order" do
        form = build(
          form_factory.to_sym,
          directive_academy_order: nil
        )
        expect(form).to be_invalid
        expect(form.errors[:directive_academy_order]).to include("Select directive academy order or academy order, whichever has been used for this conversion")
      end
    end

    describe "handover note body" do
      it "is required" do
        form = build(
          form_factory.to_sym,
          handover_note_body: ""
        )
        expect(form).to be_invalid
      end
    end
  end

  describe "urn" do
    before { mock_successful_api_responses(urn: any_args, ukprn: any_args) }

    it { is_expected.to validate_presence_of(:urn) }
    it { is_expected.to allow_value(123456).for(:urn) }
    it { is_expected.not_to allow_values(12345, 1234567).for(:urn) }

    context "when no establishment with that URN exists in the API" do
      let(:no_establishment_found_result) do
        Api::AcademiesApi::Client::Result.new(nil, Api::AcademiesApi::Client::NotFoundError.new("Could not find establishment with URN: 12345"))
      end

      before do
        allow_any_instance_of(Api::AcademiesApi::Client).to \
          receive(:get_establishment) { no_establishment_found_result }
      end

      it "is invalid" do
        form = build(form_factory.to_sym)
        expect(form).to be_invalid
      end
    end

    context "when there is another in-progress project with the same urn" do
      it "is invalid" do
        _project_with_urn = create(:conversion_project, urn: 121813)
        form = build(form_factory.to_sym)

        form.urn = 121813
        expect(form).to be_invalid
        expect(form.errors.messages[:urn]).to include I18n.t("errors.attributes.urn.duplicate")
      end
    end

    context "when there is another project with the same urn which is not completed" do
      it "is invalid" do
        _project_with_urn = create(:conversion_project, urn: 121813, assigned_to: nil)
        form = build(form_factory.to_sym)

        form.urn = 121813
        expect(form).to be_invalid
        expect(form.errors.messages[:urn]).to include I18n.t("errors.attributes.urn.duplicate")
      end
    end
  end

  describe "incoming_trust_ukprn" do
    before { mock_successful_api_responses(urn: any_args, ukprn: any_args) }

    it { is_expected.to validate_presence_of(:incoming_trust_ukprn) }

    context "when no trust with that UKPRN exists in the API" do
      let(:no_trust_found_result) do
        Api::AcademiesApi::Client::Result.new(nil, Api::AcademiesApi::Client::NotFoundError.new("No trust found with that UKPRN. Enter a valid UKPRN."))
      end

      before do
        allow_any_instance_of(Api::AcademiesApi::Client).to \
          receive(:get_trust) { no_trust_found_result }
      end

      it "is invalid" do
        form = build(form_factory.to_sym)
        expect(form).to be_invalid
      end
    end
  end

  describe "region" do
    before { mock_successful_api_responses(urn: any_args, ukprn: any_args) }

    it "sets the region code from the establishment" do
      project = build(form_factory.to_sym).save
      expect(project.region).to eq("west_midlands")
    end
  end

  describe "#save" do
    let(:establishment) { build(:academies_api_establishment) }

    before do
      mock_successful_api_establishment_response(urn: 123456, establishment:)
      mock_successful_api_trust_response(ukprn: 10061021)
    end

    context "when the form is valid" do
      it "returns a project" do
        project = build(form_factory.to_sym).save
        expect(project.class.name).to eq("Conversion::Project")
      end

      it "also creates a tasks data" do
        project = build(form_factory.to_sym).save
        expect(project.tasks_data).to be_a(Conversion::TasksData)
      end

      it "creates a note associated to the handover task" do
        form = build(
          form_factory.to_sym,
          handover_note_body: "Some important words"
        )
        form.save
        expect(Note.count).to eq(1)
        expect(Note.last.body).to eq("Some important words")
        expect(Note.last.task_identifier).to eq("handover")
      end

      context "when the project does NOT have a directive academy order" do
        it "sets directive_academy_order = false on the project" do
          form = build(
            form_factory.to_sym,
            directive_academy_order: "false"
          )
          project = form.save
          expect(project.directive_academy_order).to eq false
        end
      end

      context "when the project has a directive academy order" do
        it "sets directive_academy_order = true on the project" do
          form = build(
            form_factory.to_sym,
            directive_academy_order: "true"
          )
          project = form.save
          expect(project.directive_academy_order).to eq true
        end
      end
    end

    context "when the form is invalid" do
      before { mock_successful_api_responses(urn: any_args, ukprn: any_args) }

      it "returns nil" do
        expect(build(form_factory.to_sym, urn: nil).save).to be_nil
      end
    end
  end
end
