require "rails_helper"

RSpec.describe Conversion::Voluntary::CreateProjectForm, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:establishment_sharepoint_link) }
    it { is_expected.to validate_presence_of(:trust_sharepoint_link) }

    describe "provisional_conversion_date" do
      it { is_expected.to validate_presence_of(:provisional_conversion_date) }

      it "must be in the future" do
        form = build(
          :create_project_form,
          provisional_conversion_date: (Date.today + 1.year).at_beginning_of_month
        )
        expect(form).to be_valid

        form.provisional_conversion_date = Date.today - 1.year
        expect(form).to be_invalid
      end

      it "cannot be in the past" do
        form = build(
          :create_project_form,
          provisional_conversion_date: (Date.today + 1.year).at_beginning_of_month
        )
        expect(form).to be_valid

        form.provisional_conversion_date = Date.today - 1.year
        expect(form).to be_invalid
      end
    end

    describe "advisory_board_date" do
      it { is_expected.to validate_presence_of(:advisory_board_date) }

      it "must be in the past" do
        form = build(
          :create_project_form,
          advisory_board_date: Date.today - 1.week
        )
        expect(form).to be_valid

        form.advisory_board_date = Date.today + 1.month
        expect(form).to be_invalid
      end

      it "cannot be in the future" do
        form = build(
          :create_project_form,
          advisory_board_date: Date.today - 1.week
        )
        expect(form).to be_valid

        form.advisory_board_date = Date.today + 1.month
        expect(form).to be_invalid
      end

      context "when no date value is set" do
        it "treats the date as blank" do
          form = build(:create_project_form, advisory_board_date: nil)
          expect(form).to be_invalid
          expect(form.errors.of_kind?(:advisory_board_date, :blank)).to be true
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
        AcademiesApi::Client::Result.new(nil, AcademiesApi::Client::NotFoundError.new("Could not find establishment with URN: 12345"))
      end

      before do
        allow_any_instance_of(AcademiesApi::Client).to \
          receive(:get_establishment) { no_establishment_found_result }
      end

      it "is invalid" do
        expect(subject).to_not be_valid
      end
    end
  end

  describe "incoming_trust_ukprn" do
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
      end
    end
  end

  describe "#save" do
    let(:establishment) { build(:academies_api_establishment) }

    before do
      mock_successful_api_establishment_response(urn: 123456, establishment:)
      mock_successful_api_trust_response(ukprn: 10061021)
    end

    context "when the form is valid" do
      it "returns true" do
        expect(build(:create_project_form).save).to be true
      end
    end

    context "when the form is invalid" do
      it "returns nil" do
        expect(build(:create_project_form, urn: nil).save).to be_nil
      end
    end
  end
end
