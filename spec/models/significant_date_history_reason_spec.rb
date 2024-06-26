require "rails_helper"

RSpec.describe SignificantDateHistoryReason do
  describe "Attributes" do
    it { is_expected.to have_db_column(:reason_type).of_type :string }

    describe "reason_type" do
      it "contains all the values used by the forms" do
        earlier_values = DateHistory::Reasons::NewEarlierForm::REASONS_LIST
        later_conversion_values = DateHistory::Reasons::NewLaterForm::CONVERSION_REASONS_LIST
        later_transfer_values = DateHistory::Reasons::NewLaterForm::TRANSFER_REASONS_LIST

        all_form_values = (earlier_values + later_transfer_values + later_conversion_values).map(&:to_s).uniq.sort

        expect(all_form_values.to_set.subset?(SignificantDateHistoryReason.reason_types.keys.sort.to_set)).to be true
      end
    end
  end

  describe "Validations" do
    it { is_expected.to validate_presence_of(:reason_type) }
  end

  describe "Associations" do
    it { is_expected.to have_one(:note).dependent(:destroy) }
    it { is_expected.to belong_to(:significant_date_history).required(true) }
  end
end
