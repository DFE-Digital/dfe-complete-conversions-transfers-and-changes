require "rails_helper"

RSpec.describe ProjectGroup, type: :model do
  describe "columns" do
    it { is_expected.to have_db_column(:trust_ukprn).of_type :integer }
    it { is_expected.to have_db_column(:group_identifier).of_type :string }
  end

  describe "associations" do
    it { is_expected.to have_many(:projects) }
  end
end
