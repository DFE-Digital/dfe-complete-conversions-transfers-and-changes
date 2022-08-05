require "rails_helper"

RSpec.describe Note, type: :model do
  describe "Columns" do
    it { is_expected.to have_db_column(:body).of_type :text }
  end

  describe "Relationships" do
    it { is_expected.to belong_to(:project) }
    it { is_expected.to belong_to(:user) }
  end

  describe "Validations" do
    describe "#body" do
      it { is_expected.to validate_presence_of(:body) }
      it { is_expected.to_not allow_values("", nil).for(:body) }
    end
  end
end
