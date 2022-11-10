require "rails_helper"

RSpec.describe CreateProjectForm, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:urn) }
    it { is_expected.to validate_presence_of(:incoming_trust_ukprn) }
    it { is_expected.to validate_presence_of(:establishment_sharepoint_link) }
    it { is_expected.to validate_presence_of(:trust_sharepoint_link) }

    describe "target conversion date" do
      it "must be in the future" do
        form = build(
          :create_project_form,
          target_conversion_date: date_to_multiparameter_hash((Date.today + 1.year).at_beginning_of_month)
        )
        expect(form).to be_valid

        form.target_conversion_date = date_to_multiparameter_hash(Date.today - 1.year)
        expect(form).to be_invalid
      end

      context "when the date params are partially complete" do
        it "treats the date as invalid" do
          form = build(:create_project_form, target_conversion_date: {3 => 1, 2 => 10, 1 => nil})
          expect(form).to be_invalid
          expect(form.errors.of_kind?(:target_conversion_date, :invalid)).to be true

          form = build(:create_project_form, target_conversion_date: {3 => 1, 2 => nil, 1 => 2022})
          expect(form).to be_invalid
          expect(form.errors.of_kind?(:target_conversion_date, :invalid)).to be true
        end
      end

      context "when the month and year are missing" do
        it "treats the date as blank" do
          form = build(:create_project_form, target_conversion_date: {3 => 1, 2 => nil, 1 => nil})
          expect(form).to be_invalid
          expect(form.errors.of_kind?(:target_conversion_date, :blank)).to be true
        end
      end
    end

    describe "advisory board date" do
      it "must be in the past" do
        form = build(
          :create_project_form,
          advisory_board_date: date_to_multiparameter_hash(Date.today - 1.week)
        )
        expect(form).to be_valid

        form.advisory_board_date = date_to_multiparameter_hash(Date.today + 1.month)
        expect(form).to be_invalid
      end

      context "when the date parameters are partially complete" do
        it "treats the date as invalid" do
          form = build(:create_project_form, advisory_board_date: {3 => nil, 2 => 10, 1 => 1})
          expect(form).to be_invalid
          expect(form.errors.of_kind?(:advisory_board_date, :invalid)).to be true

          form = build(:create_project_form, advisory_board_date: {3 => 2022, 2 => nil, 1 => 1})
          expect(form).to be_invalid
          expect(form.errors.of_kind?(:advisory_board_date, :invalid)).to be true

          form = build(:create_project_form, advisory_board_date: {3 => 2022, 2 => 10, 1 => nil})
          expect(form).to be_invalid
          expect(form.errors.of_kind?(:advisory_board_date, :invalid)).to be true
        end
      end

      context "when all the date parameters are missing" do
        it "treats the date as blank" do
          form = build(:create_project_form, advisory_board_date: {3 => nil, 2 => nil, 1 => nil})
          expect(form).to be_invalid
          expect(form.errors.of_kind?(:advisory_board_date, :blank)).to be true
        end
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

  describe "#save" do
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

  def date_to_multiparameter_hash(date)
    {
      3 => date.day,
      2 => date.month,
      1 => date.year
    }
  end
end
