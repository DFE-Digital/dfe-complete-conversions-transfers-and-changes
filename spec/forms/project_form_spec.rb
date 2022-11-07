require "rails_helper"

RSpec.describe ProjectForm, type: :model do
  let(:project_form_instance) { described_class.new }

  describe "Validations" do
    before { mock_successful_api_responses(urn: any_args, ukprn: any_args) }

    describe "#advisory_board_date" do
      it { is_expected.to validate_presence_of(:advisory_board_date).on(:create) }

      context "when the date is invalid" do
        before { subject.advisory_board_date = {3 => -1, 2 => -1, 1 => -1} }

        it "adds an error to the Project" do
          expect(subject).to_not be_valid
          expect(subject.errors[:advisory_board_date]).to include(I18n.t("activemodel.errors.models.project_form.attributes.advisory_board_date.invalid"))
        end
      end
    end

    describe "#urn" do
      it { is_expected.to validate_presence_of(:urn) }
      it { is_expected.to allow_value(123456).for(:urn) }
      it { is_expected.not_to allow_values(12345, 1234567, "string").for(:urn) }

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
          expect(subject.errors[:urn]).to include(I18n.t("activemodel.errors.models.project_form.attributes.urn.no_establishment_found"))
        end
      end
    end

    describe "#incoming_trust_ukprn" do
      it { is_expected.to validate_presence_of(:incoming_trust_ukprn) }
      it { is_expected.not_to allow_value("string").for(:incoming_trust_ukprn) }

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
          expect(subject.errors[:incoming_trust_ukprn]).to include(I18n.t("activemodel.errors.models.project_form.attributes.incoming_trust_ukprn.no_trust_found"))
        end
      end
    end

    describe "#target_completion_date" do
      it { is_expected.to validate_presence_of(:target_completion_date) }

      context "when the date is invalid" do
        before { subject.target_completion_date = {3 => -1, 2 => -1, 1 => -1} }

        it "adds an error to the Project" do
          expect(subject).to_not be_valid
          expect(subject.errors[:target_completion_date]).to include(I18n.t("activemodel.errors.models.project_form.attributes.target_completion_date.invalid"))
        end
      end

      context "when the date is not on the first of the month" do
        before { subject.target_completion_date = Date.new(2025, 12, 2) }

        it "is invalid" do
          expect(subject).to_not be_valid
          expect(subject.errors[:target_completion_date]).to include(I18n.t("activemodel.errors.models.project_form.attributes.target_completion_date.must_be_first_of_the_month"))
        end
      end

      context "when date is today" do
        before { subject.target_completion_date = Date.today }

        it "is invalid" do
          expect(subject).to_not be_valid
          expect(subject.errors[:target_completion_date]).to include(I18n.t("activemodel.errors.models.project_form.attributes.target_completion_date.must_be_in_the_future"))
        end
      end

      context "when date is in the past" do
        before { subject.target_completion_date = Date.yesterday }

        it "is invalid" do
          expect(subject).to_not be_valid
          expect(subject.errors[:target_completion_date]).to include(I18n.t("activemodel.errors.models.project_form.attributes.target_completion_date.must_be_in_the_future"))
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

  describe "#create" do
    before { mock_successful_api_responses(urn: any_args, ukprn: any_args) }

    subject { project_form_instance.create }

    context "when the underlying ActiveRecord model has a validaiton error" do
      before { allow(Project).to receive(:create!).and_raise(ActiveRecord::RecordInvalid) }

      it "raises the ActiveRecord error" do
        expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context "when valid" do
      let(:project_attributes) { attributes_for(:project).except(:team_leader, :regional_delivery_officer) }

      before { project_form_instance.assign_attributes(project_attributes) }

      it "creates a project" do
        subject

        expect(Project.count).to be 1
      end
    end
  end
end
