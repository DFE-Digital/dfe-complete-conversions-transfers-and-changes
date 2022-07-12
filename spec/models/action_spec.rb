require "rails_helper"

RSpec.describe Action do
  describe "Columns" do
    it { is_expected.to have_db_column(:title).of_type :string }
    it { is_expected.to have_db_column(:order).of_type :integer }
    it { is_expected.to have_db_column(:completed).of_type :boolean }
  end

  describe "Relationships" do
    it { is_expected.to belong_to(:task) }
  end
end
