require "rails_helper"

RSpec.describe Section, type: :model do
  describe "Columns" do
    it { is_expected.to have_db_column(:title).of_type :string }
    it { is_expected.to have_db_column(:order).of_type :integer }
  end

  describe "Relationships" do
    it { is_expected.to have_many(:tasks) }
    it { is_expected.to belong_to(:project) }
  end
end
