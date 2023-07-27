require "rails_helper"

RSpec.describe Transfer::CreateProjectForm, type: :model do
  before { mock_successful_api_responses(urn: any_args, ukprn: any_args) }

  describe "validations" do
    it { is_expected.to validate_presence_of(:establishment_sharepoint_link) }
    it { is_expected.to validate_presence_of(:trust_sharepoint_link) }

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

    describe "significant_date" do
      it { is_expected.to validate_presence_of(:significant_date) }

      it "must be in the future" do
        form = build(:create_transfer_project_form, significant_date: {3 => 1, 2 => 1, 1 => 2030})
        expect(form).to be_valid

        form.significant_date = {3 => 1, 2 => 1, 1 => 2020}
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

      before do
        allow_any_instance_of(Api::AcademiesApi::Client).to \
          receive(:get_establishment) { no_establishment_found_result }
      end

      it "is invalid" do
        form = build(:create_transfer_project_form)
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
      let(:no_trust_found_result) do
        Api::AcademiesApi::Client::Result.new(nil, Api::AcademiesApi::Client::NotFoundError.new("No trust found with that UKPRN. Enter a valid UKPRN."))
      end

      before do
        allow_any_instance_of(Api::AcademiesApi::Client).to \
          receive(:get_trust) { no_trust_found_result }
      end

      it "is invalid" do
        form = build(:create_transfer_project_form)
        expect(form).to be_invalid
      end
    end
  end

  describe "outgoing_trust_ukprn" do
    before { mock_successful_api_responses(urn: any_args, ukprn: any_args) }

    it { is_expected.to validate_presence_of(:outgoing_trust_ukprn) }

    context "when no trust with that UKPRN exists in the API" do
      let(:no_trust_found_result) do
        Api::AcademiesApi::Client::Result.new(nil, Api::AcademiesApi::Client::NotFoundError.new("No trust found with that UKPRN. Enter a valid UKPRN."))
      end

      before do
        allow_any_instance_of(Api::AcademiesApi::Client).to \
          receive(:get_trust) { no_trust_found_result }
      end

      it "is invalid" do
        form = build(:create_transfer_project_form)
        expect(form).to be_invalid
      end
    end
  end

  describe "region" do
    it "sets the region code from the establishment" do
      project = build(:create_transfer_project_form).save
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
        project = build(:create_transfer_project_form).save
        expect(project.class.name).to eq("Transfer::Project")
      end

      it "also creates a tasks data" do
        project = build(:create_transfer_project_form).save
        expect(project.tasks_data).to be_a(Transfer::TasksData)
      end
    end

    context "when the form is invalid" do
      it "returns nil" do
        expect(build(:create_transfer_project_form, urn: nil).save).to be_nil
      end
    end
  end
end