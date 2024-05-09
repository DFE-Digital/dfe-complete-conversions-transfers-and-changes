require "rails_helper"

RSpec.describe ApiKey do
  describe "Columns" do
    it { is_expected.to have_db_column(:api_key).of_type :string }
    it { is_expected.to have_db_column(:expires_at).of_type :datetime }
    it { is_expected.to have_db_column(:description).of_type :string }
  end

  describe "#expired?" do
    it "returns true if expires_at is in the past" do
      api_key = ApiKey.new(api_key: "testkey", expires_at: Date.yesterday)
      expect(api_key.expired?).to be true
    end

    it "returns false if expires_at is in the future" do
      api_key = ApiKey.new(api_key: "testkey", expires_at: Date.tomorrow)
      expect(api_key.expired?).to be false
    end
  end
end
