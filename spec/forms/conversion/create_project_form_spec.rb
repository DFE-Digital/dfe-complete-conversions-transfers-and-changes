require "rails_helper"

RSpec.describe Conversion::CreateProjectForm, type: :model do
  let(:form_factory) { "create_project_form" }

  context "when the project is successfully created" do
    let(:establishment) { build(:academies_api_establishment) }
    before do
      mock_academies_api_establishment_success(urn: 123456)
      mock_academies_api_trust_success(ukprn: 10061021)

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
                                .with("TeamLeaderMailer", "new_conversion_project_created", "deliver_now", args: [team_leader, project]))
        expect(ActionMailer::MailDeliveryJob)
          .to(have_been_enqueued.on_queue("default")
                                .with("TeamLeaderMailer", "new_conversion_project_created", "deliver_now", args: [another_team_leader, project]))
      end

      context "if a team leader is deactivated" do
        it "does not send a notification to that team leader" do
          team_leader = create(:user, :team_leader, deactivated_at: Date.yesterday)

          project = build(:create_project_form, assigned_to_regional_caseworker_team: true).save
          expect(ActionMailer::MailDeliveryJob)
            .to_not(have_been_enqueued.on_queue("default")
                                  .with("TeamLeaderMailer", "new_project_created", "deliver_now", args: [team_leader, project]))
        end
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

    context "and an academy order was issued" do
      it "sets the Process the sponsored support grant task as not applicable" do
        project = build(:create_project_form, directive_academy_order: false).save

        expect(project.tasks_data.sponsored_support_grant_not_applicable).to be true
      end
    end
  end

  describe "validations" do
    before { mock_successful_api_responses(urn: any_args, ukprn: any_args) }

    it { is_expected.to validate_presence_of(:establishment_sharepoint_link) }
    it { is_expected.to validate_presence_of(:incoming_trust_sharepoint_link) }

    it "can be valid in this test" do
      attributes = valid_attributes

      form = described_class.new(attributes)

      expect(form).to be_valid
    end

    describe "provisional_conversion_date" do
      it { is_expected.to validate_presence_of(:provisional_conversion_date) }

      it "must be a valid date" do
        attributes = valid_attributes
        attributes["provisional_conversion_date(3i)"] = "31"
        attributes["provisional_conversion_date(2i)"] = "9"

        form = described_class.new(attributes)

        expect(form).to be_invalid
      end

      it "must be the first of the month" do
        attributes = valid_attributes
        attributes["provisional_conversion_date(3i)"] = "3"

        form = described_class.new(attributes)

        expect(form).to be_invalid
      end

      describe "month parameters" do
        it "cannot be be 0" do
          attributes = valid_attributes
          attributes["provisional_conversion_date(2i)"] = "0"

          form = described_class.new(attributes)

          expect(form).to be_invalid
        end

        it "cannot be be less than 0" do
          attributes = valid_attributes
          attributes["provisional_conversion_date(2i)"] = "-1"

          form = described_class.new(attributes)

          expect(form).to be_invalid
        end

        it "cannot be greater than 12" do
          attributes = valid_attributes
          attributes["provisional_conversion_date(2i)"] = "32"

          form = described_class.new(attributes)

          expect(form).to be_invalid
        end

        it "must be a number" do
          attributes = valid_attributes
          attributes["provisional_conversion_date(2i)"] = "January"

          form = described_class.new(attributes)

          expect(form).to be_invalid
        end
      end

      describe "year parameters" do
        it "must be a four digit year" do
          attributes = valid_attributes
          attributes["provisional_conversion_date(1i)"] = "24"

          form = described_class.new(attributes)

          expect(form).to be_invalid
        end

        it "cannot be be less than 2000" do
          attributes = valid_attributes
          attributes["provisional_conversion_date(1i)"] = "1999"

          form = described_class.new(attributes)

          expect(form).to be_invalid
        end

        it "cannot be greater than 3000" do
          attributes = valid_attributes
          attributes["provisional_conversion_date(1i)"] = "3001"

          form = described_class.new(attributes)

          expect(form).to be_invalid
        end

        it "must be a number" do
          attributes = valid_attributes
          attributes["provisional_conversion_date(1i)"] = "Twenty twenty four"

          form = described_class.new(attributes)

          expect(form).to be_invalid
        end
      end
    end

    describe "advisory_board_date" do
      it { is_expected.to validate_presence_of(:advisory_board_date) }

      it "must be in the past" do
        attributes = valid_attributes
        date_today = Date.today + 1.month
        attributes["advisory_board_date(3i)"] = date_today.day.to_s
        attributes["advisory_board_date(2i)"] = date_today.month.to_s
        attributes["advisory_board_date(1i)"] = date_today.year.to_s

        form = described_class.new(attributes)

        expect(form).to be_invalid
      end

      it "can be today" do
        attributes = valid_attributes
        date_today = Date.today
        attributes["advisory_board_date(3i)"] = date_today.day.to_s
        attributes["advisory_board_date(2i)"] = date_today.month.to_s
        attributes["advisory_board_date(1i)"] = date_today.year.to_s

        form = described_class.new(attributes)

        expect(form).to be_valid
      end

      it "must be a valid date" do
        attributes = valid_attributes
        attributes["advisory_board_date(3i)"] = "31"
        attributes["advisory_board_date(2i)"] = "9"

        form = described_class.new(attributes)

        expect(form).to be_invalid
      end

      describe "day parameters" do
        it "cannot be be 0" do
          attributes = valid_attributes
          attributes["advisory_board_date(3i)"] = "0"

          form = described_class.new(attributes)

          expect(form).to be_invalid
        end

        it "cannot be be less than 0" do
          attributes = valid_attributes
          attributes["advisory_board_date(3i)"] = "-1"

          form = described_class.new(attributes)

          expect(form).to be_invalid
        end

        it "cannot be greater than 31" do
          attributes = valid_attributes
          attributes["advisory_board_date(3i)"] = "32"

          form = described_class.new(attributes)

          expect(form).to be_invalid
        end

        it "must be a number" do
          attributes = valid_attributes
          attributes["advisory_board_date(3i)"] = "twenty first"

          form = described_class.new(attributes)

          expect(form).to be_invalid
        end
      end

      describe "month parameters" do
        it "cannot be be 0" do
          attributes = valid_attributes
          attributes["advisory_board_date(2i)"] = "0"

          form = described_class.new(attributes)

          expect(form).to be_invalid
        end

        it "cannot be be less than 0" do
          attributes = valid_attributes
          attributes["advisory_board_date(2i)"] = "-1"

          form = described_class.new(attributes)

          expect(form).to be_invalid
        end

        it "cannot be greater than 12" do
          attributes = valid_attributes
          attributes["advisory_board_date(2i)"] = "13"

          form = described_class.new(attributes)

          expect(form).to be_invalid
        end

        it "must be a number" do
          attributes = valid_attributes
          attributes["advisory_board_date(2i)"] = "January"

          form = described_class.new(attributes)

          expect(form).to be_invalid
        end
      end

      describe "year parameters" do
        it "must be a four digit year" do
          attributes = valid_attributes
          attributes["advisory_board_date(1i)"] = "24"

          form = described_class.new(attributes)

          expect(form).to be_invalid
        end

        it "cannot be be less than 2000" do
          attributes = valid_attributes
          attributes["advisory_board_date(1i)"] = "1999"

          form = described_class.new(attributes)

          expect(form).to be_invalid
        end

        it "cannot be greater than 3000" do
          attributes = valid_attributes
          attributes["advisory_board_date(1i)"] = "3001"

          form = described_class.new(attributes)

          expect(form).to be_invalid
        end

        it "must be a number" do
          attributes = valid_attributes
          attributes["advisory_board_date(1i)"] = "Twenty twenty four"

          form = described_class.new(attributes)

          expect(form).to be_invalid
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
      context "when the project is being handed over" do
        it "is required" do
          form = build(
            form_factory.to_sym,
            handover_note_body: ""
          )
          form.assigned_to_regional_caseworker_team = true
          expect(form).to be_invalid
        end
      end
      context "when the project is not being handed over" do
        it "is not required" do
          form = build(
            form_factory.to_sym,
            handover_note_body: ""
          )
          form.assigned_to_regional_caseworker_team = false
          expect(form).to be_valid
        end
      end
    end

    describe "two requires improvement" do
      it "cannot be empty" do
        form = build(
          form_factory.to_sym,
          two_requires_improvement: ""
        )

        expect(form).to be_invalid
        expect(form.errors[:two_requires_improvement]).to include("State if the conversion is due to 2RI. Choose yes or no")
      end
    end

    describe "new trust reference number" do
      it "is required when there is no incoming trust UKPRN" do
        form = build(:create_project_form, incoming_trust_ukprn: nil)

        expect(form).to be_invalid(:form_a_mat)
        expect(form.errors.messages[:new_trust_reference_number].first).to eql "Enter a Trust reference number (TRN)"
      end

      it "is a valid reference number" do
        form = build(:create_project_form, incoming_trust_ukprn: nil, new_trust_reference_number: "12345")

        expect(form).to be_invalid(:form_a_mat)
        expect(form.errors.messages[:new_trust_reference_number].first).to include "Trust reference number must be 'TR'"
      end
    end

    describe "new trust name" do
      it "is required when there is no incoming trust UKPRN" do
        form = build(:create_project_form, incoming_trust_ukprn: nil)

        expect(form).to be_invalid(:form_a_mat)
        expect(form.errors.messages[:new_trust_name].first).to eql "Enter a Trust name"
      end

      it "must match the value from any other project with the same reference number" do
        create(:conversion_project, new_trust_reference_number: "TR12345", new_trust_name: "The big trust")
        form = build(:create_project_form, incoming_trust_ukprn: nil, new_trust_reference_number: "TR12345", new_trust_name: "The little trust")

        expect(form).to be_invalid
        expect(form.errors.messages[:new_trust_name].first).to include "A trust with this TRN already exists"
        expect(form.errors.messages[:new_trust_name].first).to include "The big trust"
      end
    end

    describe "group id" do
      it "must be in the correct format if present" do
        form = build(:create_project_form, group_id: "12345678")

        expect(form).to be_invalid
        expect(form.errors.messages[:group_id].first)
          .to eql "A group group reference number must start GRP_ and contain 8 numbers, like GRP_00000001"

        form = build(:create_project_form, group_id: "GRP12345678")

        expect(form).to be_invalid
        expect(form.errors.messages[:group_id].first)
          .to eql "A group group reference number must start GRP_ and contain 8 numbers, like GRP_00000001"

        form = build(:create_project_form, group_id: "GRP_1234567")

        expect(form).to be_invalid
        expect(form.errors.messages[:group_id].first)
          .to eql "A group group reference number must start GRP_ and contain 8 numbers, like GRP_00000001"

        form = build(:create_project_form, group_id: "grp_1234567")

        expect(form).to be_invalid
        expect(form.errors.messages[:group_id].first)
          .to eql "A group group reference number must start GRP_ and contain 8 numbers, like GRP_00000001"

        form = build(:create_project_form, group_id: "GRP_12345678")

        expect(form).to be_valid
      end

      it "must result in a matching trust UKPRN if present" do
        ProjectGroup.create(group_identifier: "GRP_12345678", trust_ukprn: 10058884)
        form = build(:create_project_form, group_id: "GRP_12345678", incoming_trust_ukprn: 10000000)

        expect(form).to be_invalid
        expect(form.errors.messages[:group_id].first)
          .to eql "The group reference number must be for the same trust as all other group members, check the group reference number and incoming trust UKPRN"
      end

      it "is optional" do
        form = build(:create_project_form)

        expect(form).to be_valid
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

    context "when there is another active project with the same urn" do
      it "is invalid" do
        _project_with_urn = create(:conversion_project, urn: 121813, state: :active)
        form = build(form_factory.to_sym)

        form.urn = 121813
        expect(form).to be_invalid
        expect(form.errors.messages[:urn]).to include I18n.t("errors.attributes.urn.duplicate")
      end
    end

    context "when there is another inactive project with the same urn" do
      it "is invalid" do
        _project_with_urn = create(:conversion_project, urn: 121813, state: :inactive)
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

    context "when there is a Transfer project with the same urn" do
      it "is valid" do
        _project_with_urn = create(:transfer_project, urn: 121813, assigned_to: nil)
        form = build(:create_conversion_project_form)

        form.urn = 121813
        expect(form).to be_valid
      end
    end
  end

  describe "incoming_trust_ukprn" do
    before { mock_successful_api_responses(urn: any_args, ukprn: any_args) }

    it { is_expected.to validate_presence_of(:incoming_trust_ukprn).on(:existing_trust) }

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
        expect(form).to be_invalid(:existing_trust)
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
      mock_academies_api_establishment_success(urn: 123456)
      mock_academies_api_trust_success(ukprn: 10061021)
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

      context "when there is a group reference number" do
        context "when the group is a new one" do
          it "creates the group and makes the association to the project" do
            form = build(
              :create_conversion_project_form,
              group_id: "GRP_12345678"
            )

            project = form.save
            expect(ProjectGroup.count).to be 1

            group = ProjectGroup.first
            expect(project.group).to eql(group)
          end
        end

        context "when the group exists" do
          it "makes the association to the project" do
            group = create(:project_group, group_identifier: "GRP_12345678", trust_ukprn: 1234567)
            form = build(
              :create_conversion_project_form,
              incoming_trust_ukprn: 1234567,
              group_id: "GRP_12345678"
            )

            project = form.save
            expect(ProjectGroup.count).to be 1

            expect(project.group).to eql(group)
          end
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

  def valid_attributes
    advisory_board_date = Date.today - 6.months
    provisional_conversion_date = Date.today.at_beginning_of_month + 6.months

    {
      urn: "123456",
      incoming_trust_ukprn: "10061021",
      "advisory_board_date(3i)": advisory_board_date.day.to_s,
      "advisory_board_date(2i)": advisory_board_date.month.to_s,
      "advisory_board_date(1i)": advisory_board_date.year.to_s,
      advisory_board_conditions: "",
      "provisional_conversion_date(3i)": provisional_conversion_date.day.to_s,
      "provisional_conversion_date(2i)": provisional_conversion_date.month.to_s,
      "provisional_conversion_date(1i)": provisional_conversion_date.year.to_s,
      establishment_sharepoint_link: "https://educationgovuk-my.sharepoint.com/establishment",
      incoming_trust_sharepoint_link: "https://educationgovuk-my.sharepoint.com/incoming_trust",
      handover_note_body: "",
      directive_academy_order: "false",
      two_requires_improvement: "false",
      assigned_to_regional_caseworker_team: "false"
    }.with_indifferent_access
  end
end
