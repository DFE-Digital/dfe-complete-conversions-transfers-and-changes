require "rails_helper"

RSpec.describe Transfer::CreateProjectForm, type: :model do
  before { mock_all_academies_api_responses }

  describe "validations" do
    it { is_expected.to validate_presence_of(:establishment_sharepoint_link) }
    it { is_expected.to validate_presence_of(:incoming_trust_sharepoint_link) }
    it { is_expected.to validate_presence_of(:outgoing_trust_sharepoint_link) }

    it "can be valid in this test" do
      attributes = valid_attributes

      form = described_class.new(attributes)

      expect(form).to be_valid
    end

    describe "provisional_transfer_date" do
      it { is_expected.to validate_presence_of(:provisional_transfer_date) }

      it "must be a valid date" do
        attributes = valid_attributes
        attributes["provisional_transfer_date(3i)"] = "31"
        attributes["provisional_transfer_date(2i)"] = "9"

        form = described_class.new(attributes)

        expect(form).to be_invalid
      end

      it "must be the first of the month" do
        attributes = valid_attributes
        attributes["provisional_transfer_date(3i)"] = "3"

        form = described_class.new(attributes)

        expect(form).to be_invalid
      end

      describe "month parameters" do
        it "cannot be be 0" do
          attributes = valid_attributes
          attributes["provisional_transfer_date(2i)"] = "0"

          form = described_class.new(attributes)

          expect(form).to be_invalid
        end

        it "cannot be be less than 0" do
          attributes = valid_attributes
          attributes["provisional_transfer_date(2i)"] = "-1"

          form = described_class.new(attributes)

          expect(form).to be_invalid
        end

        it "cannot be greater than 12" do
          attributes = valid_attributes
          attributes["provisional_transfer_date(2i)"] = "32"

          form = described_class.new(attributes)

          expect(form).to be_invalid
        end

        it "must be a number" do
          attributes = valid_attributes
          attributes["provisional_transfer_date(2i)"] = "January"

          form = described_class.new(attributes)

          expect(form).to be_invalid
        end
      end

      describe "year parameters" do
        it "must be a four digit year" do
          attributes = valid_attributes
          attributes["provisional_transfer_date(1i)"] = "24"

          form = described_class.new(attributes)

          expect(form).to be_invalid
        end

        it "cannot be be less than 2000" do
          attributes = valid_attributes
          attributes["provisional_transfer_date(1i)"] = "1999"

          form = described_class.new(attributes)

          expect(form).to be_invalid
        end

        it "cannot be greater than 3000" do
          attributes = valid_attributes
          attributes["provisional_transfer_date(1i)"] = "3001"

          form = described_class.new(attributes)

          expect(form).to be_invalid
        end

        it "must be a number" do
          attributes = valid_attributes
          attributes["provisional_transfer_date(1i)"] = "Twenty twenty four"

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
    describe "inadequate Ofsted" do
      it "cannot be blank" do
        form = build(:create_transfer_project_form, inadequate_ofsted: "")

        expect(form).to be_invalid
      end
    end

    describe "financial, safeguarding or governance issues" do
      it "cannot be blank" do
        form = build(:create_transfer_project_form, financial_safeguarding_governance_issues: "")

        expect(form).to be_invalid
      end
    end

    describe "Outgoing trust to close" do
      it "cannot be blank" do
        form = build(:create_transfer_project_form, outgoing_trust_to_close: "")

        expect(form).to be_invalid
      end
    end

    describe "new trust reference number" do
      it "is required when there is no incoming trust UKPRN" do
        form = build(:create_transfer_project_form, incoming_trust_ukprn: nil)

        expect(form).to be_invalid(:form_a_mat)
        expect(form.errors.messages[:new_trust_reference_number].first).to eql "Enter a Trust reference number (TRN)"
      end

      it "is a valid reference number" do
        form = build(:create_transfer_project_form, incoming_trust_ukprn: nil, new_trust_reference_number: "12345")

        expect(form).to be_invalid(:form_a_mat)
        expect(form.errors.messages[:new_trust_reference_number].first).to include "Trust reference number must be 'TR'"
      end
    end

    describe "new trust name" do
      it "is required when there is no incoming trust UKPRN" do
        form = build(:create_transfer_project_form, incoming_trust_ukprn: nil)

        expect(form).to be_invalid(:form_a_mat)
        expect(form.errors.messages[:new_trust_name].first).to eql "Enter a Trust name"
      end

      it "must match the value from any other project with the same reference number" do
        create(:transfer_project, new_trust_reference_number: "TR12345", new_trust_name: "The big trust")
        form = build(:create_transfer_project_form, incoming_trust_ukprn: nil, new_trust_reference_number: "TR12345", new_trust_name: "The little trust")

        expect(form).to be_invalid
        expect(form.errors.messages[:new_trust_name].first).to include "A trust with this TRN already exists"
        expect(form.errors.messages[:new_trust_name].first).to include "The big trust"
      end
    end

    describe "group id" do
      context "when there is a group reference number" do
        context "when the group is a new one" do
          it "creates the group and makes the association to the project" do
            form = build(
              :create_transfer_project_form,
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
              :create_transfer_project_form,
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
  end

  describe "urn" do
    it { is_expected.to validate_presence_of(:urn) }
    it { is_expected.to allow_value(123456).for(:urn) }
    it { is_expected.not_to allow_values(12345, 1234567).for(:urn) }

    context "when no establishment with that URN exists in the API" do
      let(:no_establishment_found_result) do
        Api::AcademiesApi::Client::Result.new(nil, Api::AcademiesApi::Client::NotFoundError.new("Could not find establishment with URN: 12345"))
      end

      it "is invalid" do
        form = build(:create_transfer_project_form)
        mock_academies_api_establishment_not_found(urn: form.urn)

        expect(form).to be_invalid
      end
    end

    context "when there is another in-progress project with the same urn" do
      it "is invalid" do
        _project_with_urn = create(:transfer_project, urn: 121813)
        form = build(:create_transfer_project_form)

        form.urn = 121813
        expect(form).to be_invalid
        expect(form.errors.messages[:urn]).to include I18n.t("errors.attributes.urn.duplicate")
      end
    end

    context "when there is another project with the same urn which is not completed" do
      it "is invalid" do
        _project_with_urn = create(:transfer_project, urn: 121813, assigned_to: nil)
        form = build(:create_transfer_project_form)

        form.urn = 121813
        expect(form).to be_invalid
        expect(form.errors.messages[:urn]).to include I18n.t("errors.attributes.urn.duplicate")
      end
    end

    context "when there is a Conversion project with the same urn" do
      it "is valid" do
        _project_with_urn = create(:conversion_project, urn: 121813, assigned_to: nil)
        form = build(:create_transfer_project_form)

        form.urn = 121813
        expect(form).to be_valid
      end
    end
  end

  describe "incoming_trust_ukprn" do
    before { mock_successful_api_responses(urn: any_args, ukprn: any_args) }

    it { is_expected.to validate_presence_of(:incoming_trust_ukprn).on(:existing_trust) }

    context "when no trust with that UKPRN exists in the API" do
      it "is invalid" do
        form = build(:create_transfer_project_form)
        mock_academies_api_trust_not_found(ukprn: form.incoming_trust_ukprn)

        expect(form).to be_invalid(:existing_trust)
      end
    end
  end

  describe "outgoing_trust_ukprn" do
    before { mock_successful_api_responses(urn: any_args, ukprn: any_args) }

    it { is_expected.to validate_presence_of(:outgoing_trust_ukprn) }

    context "when no trust with that UKPRN exists in the API" do
      it "is invalid" do
        form = build(:create_transfer_project_form)
        mock_academies_api_trust_not_found(ukprn: form.outgoing_trust_ukprn)

        expect(form).to be_invalid
      end
    end
  end

  describe "two requires improvement" do
    it "cannot be blank" do
      form = build(:create_transfer_project_form, two_requires_improvement: "")

      expect(form).to be_invalid
    end
  end

  describe "region" do
    it "sets the region code from the establishment" do
      project = build(:create_transfer_project_form).save
      expect(project.region).to eq("west_midlands")
    end
  end

  describe "handover note body" do
    context "when the project is being handed over" do
      it "is required" do
        form = build(:create_transfer_project_form, handover_note_body: "")
        form.assigned_to_regional_caseworker_team = true

        expect(form).to be_invalid
      end
    end
    context "when the project is not being handed over" do
      it "is not required" do
        form = build(:create_transfer_project_form, handover_note_body: "")
        form.assigned_to_regional_caseworker_team = false

        expect(form).to be_valid
      end
    end
  end

  describe "advisory board conditions" do
    it "saves any that are provided" do
      form = build(:create_transfer_project_form, advisory_board_conditions: "These are the conditions.")

      project = form.save

      expect(project.advisory_board_conditions).to eql("These are the conditions.")
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
        project = build(:create_transfer_project_form).save
        expect(project.class.name).to eq("Transfer::Project")
      end

      it "also creates a tasks data" do
        project = build(:create_transfer_project_form).save
        expect(project.tasks_data).to be_a(Transfer::TasksData)
      end

      it "sets the outgoing trust" do
        project = build(:create_transfer_project_form, outgoing_trust_ukprn: 10061008).save
        expect(project.reload.outgoing_trust_ukprn).to eql(10061008)
      end

      it "creates a note associated to the handover task" do
        form = build(:create_transfer_project_form, handover_note_body: "This is the handover note.")

        form.save

        expect(Note.count).to eq(1)
        expect(Note.last.body).to eq("This is the handover note.")
        expect(Note.last.task_identifier).to eq("handover")
      end

      it "updates the tasks data with the other values" do
        form = build(
          :create_transfer_project_form, inadequate_ofsted: true,
          financial_safeguarding_governance_issues: true,
          outgoing_trust_to_close: true
        )
        form.save

        expect(Transfer::TasksData.count).to be 1
        expect(Transfer::TasksData.first.inadequate_ofsted).to be true
        expect(Transfer::TasksData.first.financial_safeguarding_governance_issues).to be true
        expect(Transfer::TasksData.first.outgoing_trust_to_close).to be true
      end

      context "when the project is being assigned to the Regional Caseworker Team" do
        it "sends a notification to team leaders" do
          team_leader = create(:user, :team_leader)
          another_team_leader = create(:user, :team_leader)

          project = build(:create_transfer_project_form, assigned_to_regional_caseworker_team: true).save

          expect(ActionMailer::MailDeliveryJob)
            .to(have_been_enqueued.on_queue("default")
                                  .with("TeamLeaderMailer", "new_transfer_project_created", "deliver_now", args: [team_leader, project]))
          expect(ActionMailer::MailDeliveryJob)
            .to(have_been_enqueued.on_queue("default")
                                  .with("TeamLeaderMailer", "new_transfer_project_created", "deliver_now", args: [another_team_leader, project]))
        end

        context "if a team leader is deactivated" do
          it "does not send a notification to that team leader" do
            team_leader = create(:user, :team_leader, deactivated_at: Date.yesterday)

            project = build(:create_transfer_project_form, assigned_to_regional_caseworker_team: true).save
            expect(ActionMailer::MailDeliveryJob)
              .to_not(have_been_enqueued.on_queue("default")
                                        .with("TeamLeaderMailer", "new_transfer_project_created", "deliver_now", args: [team_leader, project]))
          end
        end
      end

      context "when the project is NOT being assigned to the Regional Caseworker Team" do
        it "does not send a notification to team leaders" do
          _team_leader = create(:user, :team_leader)
          _another_team_leader = create(:user, :team_leader)

          _project = build(:create_transfer_project_form, assigned_to_regional_caseworker_team: false).save

          expect(ActionMailer::MailDeliveryJob).to_not(have_been_enqueued)
        end
      end
    end

    context "when the form is invalid" do
      it "returns nil" do
        expect(build(:create_transfer_project_form, urn: nil).save).to be_nil
      end
    end
  end
end
def valid_attributes
  advisory_board_date = Date.today - 6.months
  provisional_transfer_date = Date.today.at_beginning_of_month + 6.months

  {
    urn: "123456",
    incoming_trust_ukprn: "10061021",
    outgoing_trust_ukprn: "10059151",
    "advisory_board_date(3i)": advisory_board_date.day.to_s,
    "advisory_board_date(2i)": advisory_board_date.month.to_s,
    "advisory_board_date(1i)": advisory_board_date.year.to_s,
    advisory_board_conditions: "",
    "provisional_transfer_date(3i)": provisional_transfer_date.day.to_s,
    "provisional_transfer_date(2i)": provisional_transfer_date.month.to_s,
    "provisional_transfer_date(1i)": provisional_transfer_date.year.to_s,
    establishment_sharepoint_link: "https://educationgovuk-my.sharepoint.com/establishment",
    incoming_trust_sharepoint_link: "https://educationgovuk-my.sharepoint.com/incoming_trust",
    outgoing_trust_sharepoint_link: "https://educationgovuk-my.sharepoint.com/outgoing_trust",
    handover_note_body: "",
    two_requires_improvement: "false",
    assigned_to_regional_caseworker_team: "false",
    inadequate_ofsted: "false",
    financial_safeguarding_governance_issues: "false",
    outgoing_trust_to_close: false
  }.with_indifferent_access
end
