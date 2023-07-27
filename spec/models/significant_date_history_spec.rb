require "rails_helper"

RSpec.describe SignificantDateHistory do
  describe "Attributes" do
    it { is_expected.to have_db_column(:revised_date).of_type :date }
    it { is_expected.to have_db_column(:previous_date).of_type :date }
  end

  describe "Associations" do
    it { is_expected.to have_one(:note).dependent(:destroy) }
    it { is_expected.to belong_to(:project).required(true) }
  end
end
