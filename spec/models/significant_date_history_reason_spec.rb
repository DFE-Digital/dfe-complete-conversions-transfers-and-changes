require "rails_helper"

RSpec.describe SignificantDateHistoryReason do
  describe "Attributes" do
    it { is_expected.to have_db_column(:reason_type).of_type :string }
  end

  describe "Validations" do
    it { is_expected.to validate_presence_of(:reason_type) }
  end

  describe "Associations" do
    it { is_expected.to have_one(:note).dependent(:destroy) }
    it { is_expected.to belong_to(:significant_date_history).required(true) }
  end
end
