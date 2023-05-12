require "rails_helper"

RSpec.describe Contact::DirectorOfChildServices, type: :model do
  describe "Columns" do
    it { is_expected.to have_db_column(:name).of_type :string }
    it { is_expected.to have_db_column(:title).of_type :string }
    it { is_expected.to have_db_column(:email).of_type :string }
    it { is_expected.to have_db_column(:phone).of_type :string }
    it { is_expected.to have_db_column(:organisation_name).of_type :string }
    it { is_expected.to have_db_column(:type).of_type :string }
  end

  describe "Relationships" do
    it { is_expected.to belong_to(:local_authority) }
  end
end
