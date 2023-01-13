require "rails_helper"

RSpec.describe Contact, type: :model do
  describe "Columns" do
    it { is_expected.to have_db_column(:name).of_type :string }
    it { is_expected.to have_db_column(:title).of_type :string }
    it { is_expected.to have_db_column(:email).of_type :string }
    it { is_expected.to have_db_column(:phone).of_type :string }
  end

  describe "Relationships" do
    it { is_expected.to belong_to(:project) }
  end

  describe "Validations" do
    it { should validate_presence_of(:category) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:title) }

    describe "#email" do
      it { is_expected.to allow_value("test@example.com").for(:email) }
      it { is_expected.to_not allow_value("notavalidemail").for(:email) }
    end
  end
end
