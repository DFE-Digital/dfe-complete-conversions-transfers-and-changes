require "rails_helper"

RSpec.describe Task, type: :model do
  describe "Columns" do
    it { is_expected.to have_db_column(:title).of_type :string }
    it { is_expected.to have_db_column(:order).of_type :integer }
    it { is_expected.to have_db_column(:completed).of_type :boolean }
  end

  describe "Relationships" do
    it { is_expected.to belong_to(:section) }
    it { is_expected.to have_many(:actions).dependent(:destroy) }
  end
end
