require "rails_helper"

RSpec.describe Conversion::Details do
  describe "columns" do
    it { is_expected.to have_db_column(:type).of_type :string }
  end

  describe "relationships" do
    it { is_expected.to belong_to(:project) }
  end
end
