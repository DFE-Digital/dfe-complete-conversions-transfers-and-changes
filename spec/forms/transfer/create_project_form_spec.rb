require "rails_helper"

RSpec.describe Transfer::CreateProjectForm, type: :model do
  before { mock_all_academies_api_responses }

  describe "validations" do
    it { is_expected.to validate_presence_of(:establishment_sharepoint_link) }
    it { is_expected.to validate_presence_of(:incoming_trust_sharepoint_link) }
    it { is_expected.to validate_presence_of(:outgoing_trust_sharepoint_link) }

    describe "advisory_board_date" do
      it { is_expected.to validate_presence_of(:advisory_board_date) }

      it "must be in the past" do
        form = build(:create_transfer_project_form)
        expect(form).to be_valid

        form.advisory_board_date = {3 => 1, 2 => 1, 1 => 2030}
        expect(form).to be_invalid
      end

      it "cannot be in the future" do
        form = build(:create_transfer_project_form, advisory_board_date: {3 => 1, 2 => 1, 1 => 2020})
        expect(form).to be_valid

        form.advisory_board_date = {3 => 1, 2 => 1, 1 => 2030}
        expect(form).to be_invalid
      end

      context "when the date parameters are partially complete" do
        it "treats the date as invalid" do
          form = build(:create_transfer_project_form, advisory_board_date: {3 => nil, 2 => 10, 1 => 1})
          expect(form).to be_invalid
          expect(form.errors.of_kind?(:advisory_board_date, :invalid)).to be true

          form = build(:create_transfer_project_form, advisory_board_date: {3 => 2022, 2 => nil, 1 => 1})
          expect(form).to be_invalid
          expect(form.errors.of_kind?(:advisory_board_date, :invalid)).to be true

          form = build(:create_transfer_project_form, advisory_board_date: {3 => 2022, 2 => 10, 1 => nil})
          expect(form).to be_invalid
          expect(form.errors.of_kind?(:advisory_board_date, :invalid)).to be true
        end
      end

      context "when all the date parameters are missing" do
        it "treats the date as blank" do
          form = build(:create_transfer_project_form, advisory_board_date: {3 => nil, 2 => nil, 1 => nil})
          expect(form).to be_invalid
          expect(form.errors.of_kind?(:advisory_board_date, :blank)).to be true
        end
      end

      context "when no date value is set" do
        it "treats the date as blank" do
          form = build(:create_transfer_project_form, advisory_board_date: nil)
          expect(form).to be_invalid
          expect(form.errors.of_kind?(:advisory_board_date, :blank)).to be true
        end
      end

      context "when the date doesn't exist" do
        it "treats the date as invalid" do
          form = build(:create_transfer_project_form, advisory_board_date: {3 => 31, 2 => 2, 1 => 2030})
          expect(form).to be_invalid
          expect(form.errors.of_kind?(:advisory_board_date, :invalid)).to be true
        end
      end

      context "when the isn't a date" do
        it "treats the date as invalid" do
          form = build(:create_transfer_project_form, advisory_board_date: {3 => -1, 2 => -1, 1 => 0})
          expect(form).to be_invalid
          expect(form.errors.of_kind?(:advisory_board_date, :invalid)).to be true

          form = build(:create_transfer_project_form, advisory_board_date: {3 => "not", 2 => "a", 1 => "date"})
          expect(form).to be_invalid
          expect(form.errors.of_kind?(:advisory_board_date, :invalid)).to be true
        end
      end
    end

    describe "#provisional_transfer_date" do
      it { is_expected.to validate_presence_of(:provisional_transfer_date) }

      it "must be in the future" do
        form = build(:create_transfer_project_form, provisional_transfer_date: {3 => 1, 2 => 1, 1 => 2030})
        expect(form).to be_valid

        form.provisional_transfer_date = {3 => 1, 2 => 1, 1 => 2020}
        expect(form).to be_invalid
      end
    end

    describe "#check_incoming_trust_and_outgoing_trust" do
      it "throws an error when the incoming trust and outgoing trust are the same" do
        form = build(:create_transfer_project_form, incoming_trust_ukprn: 10061021)
        form.outgoing_trust_ukprn = 10061021

        expect(form).to be_invalid
        expect(form.errors.messages[:incoming_trust_ukprn]).to include I18n.t("errors.attributes.incoming_trust_ukprn.ukprns_must_not_match")
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
        mock_establishment_not_found(urn: form.urn)

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

    it { is_expected.to validate_presence_of(:incoming_trust_ukprn) }

    context "when no trust with that UKPRN exists in the API" do
      it "is invalid" do
        form = build(:create_transfer_project_form)
        mock_trust_not_found(ukprn: form.incoming_trust_ukprn)

        expect(form).to be_invalid
      end
    end
  end

  describe "outgoing_trust_ukprn" do
    before { mock_successful_api_responses(urn: any_args, ukprn: any_args) }

    it { is_expected.to validate_presence_of(:outgoing_trust_ukprn) }

    context "when no trust with that UKPRN exists in the API" do
      it "is invalid" do
        form = build(:create_transfer_project_form)
        mock_trust_not_found(ukprn: form.outgoing_trust_ukprn)

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
      mock_successful_api_establishment_response(urn: 123456, establishment:)
      mock_successful_api_trust_response(ukprn: 10061021)
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
          financial_safeguarding_governance_issues: true
        )
        form.save

        expect(Transfer::TasksData.count).to be 1
        expect(Transfer::TasksData.first.inadequate_ofsted).to be true
        expect(Transfer::TasksData.first.financial_safeguarding_governance_issues).to be true
      end
    end

    context "when the form is invalid" do
      it "returns nil" do
        expect(build(:create_transfer_project_form, urn: nil).save).to be_nil
      end
    end
  end
end
