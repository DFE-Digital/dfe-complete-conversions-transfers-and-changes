require "rails_helper"

RSpec.describe LocalAuthority do
  describe "Columns" do
    it { is_expected.to have_db_column(:name).of_type :string }
    it { is_expected.to have_db_column(:code).of_type :string }
    it { is_expected.to have_db_column(:address_1).of_type :string }
    it { is_expected.to have_db_column(:address_2).of_type :string }
    it { is_expected.to have_db_column(:address_3).of_type :string }
    it { is_expected.to have_db_column(:address_town).of_type :string }
    it { is_expected.to have_db_column(:address_county).of_type :string }
    it { is_expected.to have_db_column(:address_postcode).of_type :string }
  end

  describe "Validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:code) }
    it { is_expected.to validate_presence_of(:address_1) }
    it { is_expected.to validate_presence_of(:address_postcode) }

    describe "#address_postcode" do
      it { is_expected.to allow_value("N1C 4AG").for(:address_postcode) }
      it { is_expected.to_not allow_value("thisisnotapostcode").for(:address_postcode) }
    end

    describe "#code" do
      it "validates uniqueness" do
        _local_authority_1 = create(:local_authority, code: 201)
        local_authority_2 = build(:local_authority, code: 201)

        expect(local_authority_2).to_not be_valid
      end
    end
  end
end
