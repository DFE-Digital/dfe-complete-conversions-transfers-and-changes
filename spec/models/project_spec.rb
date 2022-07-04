require "rails_helper"

RSpec.describe Project, type: :model do
  describe "Columns" do
    it { is_expected.to have_db_column(:urn).of_type :integer }
  end

  describe "Validations" do
    it "urn" do
      is_expected.to validate_presence_of(:urn)
      is_expected.to validate_numericality_of(:urn).only_integer
    end
  end

  describe "Relationships" do
    it { is_expected.to have_many(:sections) }
  end
end
